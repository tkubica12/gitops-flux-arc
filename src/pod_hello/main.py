from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from uuid import uuid4
import os

app = FastAPI()

# Load environment variables from .env file
load_dotenv()
namespace = os.getenv("NAMESPACE")
pod_name = os.getenv("POD_NAME")
pod_id = os.getenv("POD_ID")
cluster_name = os.getenv("CLUSTER_NAME")

@app.get("/")
async def info():
    return {
        "namespace": namespace,
        "pod_name": pod_name,
        "pod_id": pod_id,
        "cluster_name": cluster_name
    }