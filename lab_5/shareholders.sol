pragma solidity >=0.4.22 <0.6.0;

contract shareholders{

    struct Answer{
      uint question_id;
      address voterAddress;
      bool vote;
    }

    struct Question {
      uint id;
      string question;
      bool closed;
    }

    address owner;

    uint questionId = 1;

    address[] voters;
    Answer[] answers;
    Question[] questions;


    constructor() public{
        owner = msg.sender;
    }

    function getAddress() public view returns(address senderAddress){
        return msg.sender;
    }


    function addQuestion(string memory question) public returns(uint){
        require( owner == msg.sender, 'Only contract owner can add questions');
        questions.push(Question(questionId, question, false));
        questionId++;
        return questionId;
    }

    function removeQuestion(uint question_id) public{
  		require( owner == msg.sender, 'Only contract owner can add questions');
  		for (uint i = 0; i<questions.length; i++){
  		    if(questions[i].id == question_id){
  		        delete questions[i];
  		        break;
  		    }
  		}
    }

    function closeVote(uint question_id) public{
      require( owner == msg.sender, 'Only contract owner can add questions');
      for (uint i = 0; i<questions.length; i++){
          if(questions[i].id == question_id){
              questions[i].closed = true;
              break;
          }
      }
    }

    function addVoter(address voterAddress) public {
        require( owner == msg.sender, 'Only contract owner can add voters');
        require( voterAddress != msg.sender, 'You cannot add yourself as a voter');
        for(uint i = 0 ; i< voters.length; i++){
            require( voters[i] != voterAddress, 'Voter already exists');
        }
        voters.push(voterAddress);
    }


    function removeVoter(address voter_address) public{
		require( owner == msg.sender, 'Only contract owner can remove voters');

        for (uint i = 0; i<voters.length; i++){
			if(voters[i] == voter_address){
				delete voters[i];
				break;
			}
        }

		for (uint i = 0; i<questions.length; i++){
			uint question_id = questions[i].id;
			for(uint j = 0; j< answers.length; j++){
				if(answers[j].voterAddress == voter_address && answers[j].question_id == question_id){
					delete answers[j];
					break;
				}
			}
        }
    }


    function getQuestions() public view returns(string memory ){
        bool answered = false;
        string memory questionsString = "";
        for (uint i = 0; i<questions.length; i++){
            answered = false;
            for(uint j = 0; j < answers.length; j++){
				if(answers[j].voterAddress == msg.sender && questions[i].id == answers[j].question_id){
					answered  = true;
					break;
				}
            }
            if(!answered){
                string memory que = questions[i].question;
                questionsString = string(abi.encodePacked(questionsString, ", ",que));
            }
        }
        return questionsString;
    }


    function vote(uint question_id, bool answer) public returns (string memory state){
		for (uint i = 0; i<questions.length; i++){
				if( question_id == questions[i].id){
                    if(questions[i].closed){
                        return "The vote for this question is closed";
                    }
					for(uint j = 0; j < answers.length; j++){
						if(answers[j].voterAddress == msg.sender){
							return "You have already voted for this question";
						}

					}
					answers.push(Answer(question_id,msg.sender, answer));
				}
		}
		return "You have voted successfully";
    }


    function getVoteResult(uint question_id) public view returns(string memory result){

        for(uint i = 0; i< questions.length; i++){
          if(questions[i].id == question_id){
            if(! questions[i].closed){
              return "this question vote is still open";
            }
             uint total = 0;
            uint yes = 0;
            for(uint j = 0 ; j < answers.length; j++){
                if(answers[j].question_id == question_id){
                    total++;
                    if(answers[j].vote ){
                        yes++;
                    }
                }
            }
            bool voteResult = yes *2 > total;
            if( voteResult){
                return "The mojority has voted yes for this question";
            }
                return "The majority has voted no for this question";
            }
        }
        return "The question does not exist in this contract";
    }

}
