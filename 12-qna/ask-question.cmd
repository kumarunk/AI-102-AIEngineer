@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

rem Set variables
set prediction_url="https://ai102languageqnaservicekk.cognitiveservices.azure.com/language/:query-knowledgebases?projectName=LearnFAQ&api-version=2021-10-01&deploymentName=production"
set key="a2e51c3bbfdf48df86f588896a100973"

curl -X POST !prediction_url! -H "Ocp-Apim-Subscription-Key: !key!" -H "Content-Type: application/json" -d "{'question': 'What is a learning Path?' }"