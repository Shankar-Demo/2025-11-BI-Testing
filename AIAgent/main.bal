import ballerina/ai;
import ballerina/http;

listener ai:Listener MathAgentListener = new (listenOn = check http:getDefaultListener());

service /MathAgent on MathAgentListener {
    private final ai:Agent MathAgentAgent;

    function init() returns error? {
        self.MathAgentAgent = check new (
            systemPrompt = {role: string `Math Tutor`, instructions: string `You are a math tutor. Your job is to analyse the questions and respond only for mathematical questions`}, model = MathAgentModel, tools = []
        );
    }

    resource function post chat(@http:Payload ai:ChatReqMessage request) returns ai:ChatRespMessage|error {
        string stringResult = check self.MathAgentAgent.run(request.message, request.sessionId);
        return {message: stringResult};
    }
}
