import ballerina/ai;
import ballerina/http;

listener ai:Listener MathTutorListener = new (listenOn = check http:getDefaultListener());

service /MathTutor on MathTutorListener {
    private final ai:Agent MathTutorAgent;

    function init() returns error? {
        self.MathTutorAgent = check new (
            systemPrompt = {role: string `Math Tutor`, instructions: string `You are a helpful math tutor. Your job is to analyse the questions and respond only to math questions. `}, model = MathTutorModel, tools = []
        );
    }

    resource function post chat(@http:Payload ai:ChatReqMessage request) returns ai:ChatRespMessage|error {
        string stringResult = check self.MathTutorAgent.run(request.message, request.sessionId);
        return {message: stringResult};
    }
}
