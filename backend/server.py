from fastapi import FastAPI, Request, HTTPException
from ai_client import AIClient

app = FastAPI()

# Initialize AI client
ai_client = AIClient()
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

# Enable CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/health")
async def health_check():
    return {"status": "ok"}

@app.post("/npc/dialogue")
async def npc_dialogue(request: Request):
    data = await request.json()

    # Get conversation history if available
    conversation_history = data.get("conversation_history", [])

    # Get NPC response
    response = ai_client.get_npc_response(
        data.get("npc_id", ""),
        data.get("player_message", ""),
        data.get("npc_state", {}),
        data.get("case_context", {}),
        data.get("discovered_clues", []),
        conversation_history
    )

    return response

@app.get("/usage")
async def get_usage():
    return ai_client.get_status()

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="127.0.0.1", port=8000)