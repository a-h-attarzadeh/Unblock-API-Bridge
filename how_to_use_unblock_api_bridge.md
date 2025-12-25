# How to Use Unblock-API-Bridge

## Overview

Unblock-API-Bridge is a reverse proxy service that allows you to access blocked AI APIs and external services from restricted regions. It acts as an intermediary between your application and the target APIs, bypassing geographic restrictions and sanctions.

**Base URL:** `https://unblock.darkube.app`

## Architecture

```
[Your Application] → [Unblock-API-Bridge] → [Target API (OpenAI/Telegram/etc.)]
```

## Available Services

The proxy supports the following services:

| Service | Proxy Path | Original API URL |
|---------|-----------|-----------------|
| Telegram Bot API | `/telegram/` | `https://api.telegram.org` |
| OpenAI API | `/openai/` | `https://api.openai.com` |
| Google Gemini API | `/gemini/` | `https://generativelanguage.googleapis.com` |
| OpenRouter API | `/openrouter/` | `https://openrouter.ai` |

## Usage Pattern

To use any service, replace the original API base URL with the proxy base URL and add the service prefix:

**Original:** `https://api.openai.com/v1/chat/completions`  
**Proxied:** `https://unblock.darkube.app/openai/v1/chat/completions`

The proxy automatically removes the service prefix (`/openai/`, `/telegram/`, etc.) before forwarding the request to the target API.

---

## 1. Telegram Bot API

### Base URL
```
https://unblock.darkube.app/telegram/
```

### Example: Get Bot Information

**Original API:**
```
GET https://api.telegram.org/bot<TOKEN>/getMe
```

**Using Proxy:**
```
GET https://unblock.darkube.app/telegram/bot<TOKEN>/getMe
```

### Code Examples

#### Python
```python
import requests

BOT_TOKEN = "your_bot_token"
PROXY_BASE = "https://unblock.darkube.app/telegram"

# Get bot information
response = requests.get(f"{PROXY_BASE}/bot{BOT_TOKEN}/getMe")
bot_info = response.json()
print(bot_info)

# Send a message
chat_id = "123456789"
message = "Hello from proxy!"
send_url = f"{PROXY_BASE}/bot{BOT_TOKEN}/sendMessage"
requests.post(send_url, json={
    "chat_id": chat_id,
    "text": message
})
```

#### JavaScript/Node.js
```javascript
const axios = require('axios');

const BOT_TOKEN = 'your_bot_token';
const PROXY_BASE = 'https://unblock.darkube.app/telegram';

// Get bot information
async function getBotInfo() {
    const response = await axios.get(`${PROXY_BASE}/bot${BOT_TOKEN}/getMe`);
    console.log(response.data);
}

// Send a message
async function sendMessage(chatId, text) {
    await axios.post(`${PROXY_BASE}/bot${BOT_TOKEN}/sendMessage`, {
        chat_id: chatId,
        text: text
    });
}
```

#### cURL
```bash
# Get bot info
curl https://unblock.darkube.app/telegram/bot<TOKEN>/getMe

# Send message
curl -X POST https://unblock.darkube.app/telegram/bot<TOKEN>/sendMessage \
  -H "Content-Type: application/json" \
  -d '{"chat_id": "123456789", "text": "Hello!"}'
```

---

## 2. OpenAI API

### Base URL
```
https://unblock.darkube.app/openai/
```

### Example: Chat Completions

**Original API:**
```
POST https://api.openai.com/v1/chat/completions
```

**Using Proxy:**
```
POST https://unblock.darkube.app/openai/v1/chat/completions
```

### Code Examples

#### Python
```python
import requests

API_KEY = "sk-your-openai-key"
PROXY_BASE = "https://unblock.darkube.app/openai"

# Chat completion
response = requests.post(
    f"{PROXY_BASE}/v1/chat/completions",
    headers={
        "Authorization": f"Bearer {API_KEY}",
        "Content-Type": "application/json"
    },
    json={
        "model": "gpt-4",
        "messages": [
            {"role": "user", "content": "Hello, how are you?"}
        ]
    }
)
result = response.json()
print(result["choices"][0]["message"]["content"])

# Streaming (for real-time responses)
response = requests.post(
    f"{PROXY_BASE}/v1/chat/completions",
    headers={
        "Authorization": f"Bearer {API_KEY}",
        "Content-Type": "application/json"
    },
    json={
        "model": "gpt-4",
        "messages": [{"role": "user", "content": "Tell me a story"}],
        "stream": True
    },
    stream=True
)

for line in response.iter_lines():
    if line:
        print(line.decode('utf-8'))
```

#### JavaScript/Node.js
```javascript
const axios = require('axios');

const API_KEY = 'sk-your-openai-key';
const PROXY_BASE = 'https://unblock.darkube.app/openai';

// Chat completion
async function chatCompletion(messages) {
    const response = await axios.post(
        `${PROXY_BASE}/v1/chat/completions`,
        {
            model: 'gpt-4',
            messages: messages
        },
        {
            headers: {
                'Authorization': `Bearer ${API_KEY}`,
                'Content-Type': 'application/json'
            }
        }
    );
    return response.data;
}

// Usage
chatCompletion([
    { role: 'user', content: 'Hello, how are you?' }
]).then(result => {
    console.log(result.choices[0].message.content);
});
```

#### cURL
```bash
curl https://unblock.darkube.app/openai/v1/chat/completions \
  -H "Authorization: Bearer sk-your-openai-key" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-4",
    "messages": [
      {"role": "user", "content": "Hello!"}
    ]
  }'
```

---

## 3. Google Gemini API

### Base URL
```
https://unblock.darkube.app/gemini/
```

### Example: List Models

**Original API:**
```
GET https://generativelanguage.googleapis.com/v1/models?key=<API_KEY>
```

**Using Proxy:**
```
GET https://unblock.darkube.app/gemini/v1/models?key=<API_KEY>
```

### Code Examples

#### Python
```python
import requests

API_KEY = "your-gemini-api-key"
PROXY_BASE = "https://unblock.darkube.app/gemini"

# List models
response = requests.get(f"{PROXY_BASE}/v1/models?key={API_KEY}")
models = response.json()
print(models)

# Generate content
response = requests.post(
    f"{PROXY_BASE}/v1/models/gemini-pro:generateContent?key={API_KEY}",
    json={
        "contents": [{
            "parts": [{"text": "Write a haiku about programming"}]
        }]
    }
)
result = response.json()
print(result)
```

#### JavaScript/Node.js
```javascript
const axios = require('axios');

const API_KEY = 'your-gemini-api-key';
const PROXY_BASE = 'https://unblock.darkube.app/gemini';

// List models
async function listModels() {
    const response = await axios.get(`${PROXY_BASE}/v1/models?key=${API_KEY}`);
    return response.data;
}

// Generate content
async function generateContent(prompt) {
    const response = await axios.post(
        `${PROXY_BASE}/v1/models/gemini-pro:generateContent?key=${API_KEY}`,
        {
            contents: [{
                parts: [{ text: prompt }]
            }]
        }
    );
    return response.data;
}
```

#### cURL
```bash
# List models
curl "https://unblock.darkube.app/gemini/v1/models?key=YOUR_API_KEY"

# Generate content
curl -X POST \
  "https://unblock.darkube.app/gemini/v1/models/gemini-pro:generateContent?key=YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "contents": [{
      "parts": [{"text": "Hello!"}]
    }]
  }'
```

---

## 4. OpenRouter API

### Base URL
```
https://unblock.darkube.app/openrouter/
```

### Example: Chat Completions

**Original API:**
```
POST https://openrouter.ai/api/v1/chat/completions
```

**Using Proxy:**
```
POST https://unblock.darkube.app/openrouter/api/v1/chat/completions
```

### Code Examples

#### Python
```python
import requests

API_KEY = "sk-or-your-openrouter-key"
PROXY_BASE = "https://unblock.darkube.app/openrouter"

# Chat completion
response = requests.post(
    f"{PROXY_BASE}/api/v1/chat/completions",
    headers={
        "Authorization": f"Bearer {API_KEY}",
        "Content-Type": "application/json",
        "HTTP-Referer": "https://your-app.com",  # Optional but recommended
        "X-Title": "Your App Name"  # Optional but recommended
    },
    json={
        "model": "openai/gpt-4",
        "messages": [
            {"role": "user", "content": "Hello!"}
        ]
    }
)
result = response.json()
print(result)
```

#### JavaScript/Node.js
```javascript
const axios = require('axios');

const API_KEY = 'sk-or-your-openrouter-key';
const PROXY_BASE = 'https://unblock.darkube.app/openrouter';

async function chatCompletion(messages, model = 'openai/gpt-4') {
    const response = await axios.post(
        `${PROXY_BASE}/api/v1/chat/completions`,
        {
            model: model,
            messages: messages
        },
        {
            headers: {
                'Authorization': `Bearer ${API_KEY}`,
                'Content-Type': 'application/json',
                'HTTP-Referer': 'https://your-app.com',
                'X-Title': 'Your App Name'
            }
        }
    );
    return response.data;
}
```

#### cURL
```bash
curl https://unblock.darkube.app/openrouter/api/v1/chat/completions \
  -H "Authorization: Bearer sk-or-your-openrouter-key" \
  -H "Content-Type: application/json" \
  -H "HTTP-Referer: https://your-app.com" \
  -H "X-Title: Your App Name" \
  -d '{
    "model": "openai/gpt-4",
    "messages": [
      {"role": "user", "content": "Hello!"}
    ]
  }'
```

---

## Important Notes

### 1. URL Path Transformation

The proxy automatically removes the service prefix from the path:
- Request: `https://unblock.darkube.app/openai/v1/models`
- Forwarded to: `https://api.openai.com/v1/models`

The `/openai/` prefix is stripped before forwarding.

### 2. Headers

All original headers are preserved and forwarded to the target API. The proxy adds:
- `X-Real-IP`: Your client's IP address
- `X-Forwarded-For`: Forwarded IP chain
- `X-Forwarded-Proto`: Protocol (http/https)

### 3. Authentication

Use the same authentication methods as the original APIs:
- **OpenAI/OpenRouter**: `Authorization: Bearer <TOKEN>` header
- **Gemini**: `key=<API_KEY>` query parameter
- **Telegram**: Token in URL path: `/bot<TOKEN>/method`

### 4. Streaming Support

The proxy supports streaming responses (e.g., OpenAI streaming). Buffering is disabled to allow real-time responses.

### 5. Request Size Limit

Maximum request body size: **100MB**

### 6. Timeouts

- Connection timeout: 60 seconds
- Send timeout: 60 seconds
- Read timeout: 60 seconds

### 7. Error Handling

The proxy forwards all HTTP status codes and error messages from the target APIs. Handle errors as you would with the original APIs.

### 8. Health Check

You can check if the service is running:
```bash
curl https://unblock.darkube.app/
# Returns: OK
```

---

## Best Practices

1. **Error Handling**: Always implement proper error handling for network issues and API errors.

2. **Rate Limiting**: Respect the rate limits of the target APIs. The proxy doesn't implement rate limiting.

3. **Security**: Never expose API keys in client-side code. Keep them secure on the server side.

4. **Retry Logic**: Implement exponential backoff for failed requests.

5. **Monitoring**: Monitor response times and error rates to detect issues early.

---

## Example: Complete Integration

### Python Example (OpenAI with Error Handling)

```python
import requests
import time
from typing import Optional

class OpenAIProxyClient:
    def __init__(self, api_key: str):
        self.api_key = api_key
        self.base_url = "https://unblock.darkube.app/openai"
        self.headers = {
            "Authorization": f"Bearer {api_key}",
            "Content-Type": "application/json"
        }
    
    def chat(self, messages: list, model: str = "gpt-4", max_retries: int = 3) -> Optional[dict]:
        """Send a chat completion request with retry logic."""
        url = f"{self.base_url}/v1/chat/completions"
        data = {
            "model": model,
            "messages": messages
        }
        
        for attempt in range(max_retries):
            try:
                response = requests.post(url, headers=self.headers, json=data, timeout=60)
                response.raise_for_status()
                return response.json()
            except requests.exceptions.RequestException as e:
                if attempt == max_retries - 1:
                    raise
                wait_time = 2 ** attempt  # Exponential backoff
                time.sleep(wait_time)
        
        return None

# Usage
client = OpenAIProxyClient("sk-your-key")
result = client.chat([
    {"role": "user", "content": "What is Python?"}
])
print(result["choices"][0]["message"]["content"])
```

---

## Troubleshooting

### Common Issues

1. **404 Not Found**: Ensure you're using the correct service prefix (`/openai/`, `/telegram/`, etc.)

2. **401 Unauthorized**: Check your API key/token is correct and properly formatted

3. **Timeout Errors**: Increase timeout values or check network connectivity

4. **502 Bad Gateway**: The proxy service might be temporarily unavailable. Retry after a few seconds.

---

## Support

For issues or questions, refer to the original API documentation:
- [Telegram Bot API](https://core.telegram.org/bots/api)
- [OpenAI API](https://platform.openai.com/docs)
- [Google Gemini API](https://ai.google.dev/docs)
- [OpenRouter API](https://openrouter.ai/docs)

---

## License

This proxy service is provided as-is. Use responsibly and in accordance with the terms of service of the target APIs.

