import argparse
import boundingbox as bb
import database as db
import data_loader as dl
import kdtree as kd
import matplotlib.pyplot as plt
import matplotlib
import plotter as pl
import matplotlib.animation as animation
import matplotlib.patches as mpatches
import matplotlib.colors as mcolors
import numpy as np

# lab
import quadtree as qt

from matplotlib.collections import PatchCollection


if __name__ == '__main__':
	
	parser = argparse.ArgumentParser(description = 'KDTree plotting program.')

	parser.add_argument('--filename', help='file containing spatial information.',type=str)
	parser.add_argument('--max-depth', help='the maximum depth of the KDTree.',type=int,default=3)
	parser.add_argument('--max-elements', help='the maximum of elements in a KDTree leave.',type=int, default=1000)
	parser.add_argument('--bbox-depth', help='display the bounding-boxes at specific depth.',type=int,default=2)
	parser.add_argument('--plot', help='choose what to plot (kdtree-bb,storage)',type=str,default="kdtree-bb")
	parser.add_argument('--range-query', help='bbox range query, "1 2; 3 4"',type=str)	
	parser.add_argument('--closest', help='closest point query, "1 2"',type=str)
	parser.add_argument('--quadtree', help='add quadtree indexing depth, 2',type=int,default=5)
	parser.add_argument('--quadlevel', help='select all points up to this level, 2',type=int,default=4)
	parser.add_argument('--quadshow', help='display the quadtree',type=bool,default=False)
	

	args = parser.parse_args()

	
	# Construct database	
	fields = ["x","y"]
	if args.quadtree:
		fields.append("quad")
	dtb =  db.Database(fields)
	field_idx = dtb.fields()
	
	# Load the data
	data_loader = dl.DataLoader()
	data_loader.load(args,dtb)

	# Create KDTree
	tree = kd.KDTree(dtb, {'max-depth' : args.max_depth, 'max-elements' : args.max_elements})

	plotter = pl.Plotter(tree,dtb,args)


	# Testing: Implementing the QuadTree
	if args.quadtree:
		quadtree = qt.QuadTree(tree.bounding_box(), args.quadtree)
		if args.quadshow:
			plotter.add_quadtree(quadtree)

	# Testing: Implementing the KDTree
	if args.closest:
		# This is for testing, to check if your closest query is correclty implemented

		# Step 1 query and fetch		
		closest_query = np.fromstring(args.closest,dtype=float, sep=' ')
		closest_records = dtb.query(tree.closest(closest_query))

		# Step 2 compare found geometry with closest_point	
		geometries= [ [x[field_idx["x"]],x[field_idx["y"]] ] for x in closest_records]
		distances = [np.linalg.norm(closest_query - geom) for geom in geometries]
		ordered = np.argsort(distances)
		
		# Step 3 plot search and result point
		plotter.add_closest_query(closest_query,geometries[ordered[0]])		

	
	# Using the QuadTree depth to subsample the KDTree			
    if args.quadtree:

        # :To be implemented by the student:•
        # initially set the quad field for all records to the max quad-level
        # iterate through all levels of the quadtree in reverse order. (maxdepth to 0) for every box inside that level obtain its centroid.
        # use this centroid to obtain the list of closest points inside the KDTree
        # find the closest point inside that list
        # update the ‘quad‘ field corresponding to that point to the current quadlevel
        
		quadlevel = args.quadlevel
		#seting up the quadtree
        quadtree = qt.QuadTree(tree.bounding_box(), args.quadtree)
        tree_quads = quadtree.quads
		#looping through the levels in reverse
        for idx in range(len(tree_quads) - 1, -1, -1):
            level_quads = tree_quads[idx]
            for quad in level_quads:
                centroid = quad.centroid()
                closest_records = dtb.query(tree.closest(centroid))
                #print("closest records",closest_records, "centroid ", centroid, "idx",idx)
                minumum_dist = sys.maxsize
                closest = None
				#finding the closest point
                for close in closest_records:
                    distance = math.sqrt(((centroid[0] - close[1]) ** 2) + ((centroid[1] - close[2]) ** 2))
                    if(distance< minumum_dist):
                        minumum_dist = distance
                        closest = close
                if closest is not None:
                    print("closest", closest)
            		#updating the quad field of the closest point
					dtb.update_field(closest[0], 'quad', idx)

					
	plotter.plot()




