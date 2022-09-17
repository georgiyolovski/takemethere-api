# TakeMeThere API
A REST API for the TakeMeThere app, written in Elixir and Phoenix

## Endpoints

### Health Check

*GET* `/api/health`

#### Response
200 OK
```json
{
  "status": "UP"
}
```

### Register

*POST* `/api/auth/register`

```json
{
    "email": "test@test3.com",
    "first_name": "Test",
    "last_name": "T",
    "password": "test123"
}
```

#### Response
```json
{
  "token": "eyJhbGciOiJIUzUxMiIsI..."
}
```

### Login

*POST* `/api/auth/login`

```json
{
    "email": "test@test3.com",
    "password": "test123"
}
```

#### Response
```json
{
  "token": "eyJhbGciOiJIUzUxMiIsI..."
}
```

### Google Register

*POST* `/api/auth/register/google`

```json
{
    "token": "eyjgbvyur..."
}
```

#### Response
```json
{
  "token": "eyJhbGciOiJIUzUxMiIsI..."
}
```

### Google Login

*POST* `/api/auth/login/google`

```json
{
    "token": "eyjgbvyur..."
}
```

#### Response
```json
{
  "token": "eyJhbGciOiJIUzUxMiIsI..."
}
```

### Search Locations

#### Headers
`Authorization: {token here}`

*GET* `/api/locations`
*GET* `/api/locations=name=rome`

#### Response
```json
[
    {
        "country": "Italy",
        "id": 2138,
        "name": "Rome"
    },
    {
        "country": "Russian Federation",
        "id": 2774,
        "name": "Kostroma"
    },
    {
        "country": "Norway",
        "id": 2509,
        "name": "Tromsø"
    },
    {
        "country": "Australia",
        "id": 283,
        "name": "Roma"
    },
    {
        "country": "Dominican Republic",
        "id": 2182,
        "name": "La Romana"
    }
]
```

### Create Search Session

#### Headers
`Authorization: {token here}`

*POST* `/api/search_sessions`

```json
{
  "location_id" : 1,
  "start_date" : "2020-09-01",
  "end_date" : "2020-09-01",
  "adults" : 1,
  "children" : 2,
  "activities" : ["beach", "shopping"]
}
```

#### Response

```json
{
  "activities": [
      "beach",
      "shopping"
  ],
  "adults": 1,
  "children": 2,
  "end_date": "2020-09-01",
  "id": 7,
  "location_id": 1,
  "start_date": "2020-09-01",
  "user_id": 4
}
```

### Get Serach Sessin

#### Headers
`Authorization: {token here}`

*GET* `/api/search_sessions/1`

### Response

```json
{
  "activities": [
      "beach",
      "shopping"
  ],
  "adults": 1,
  "children": 2,
  "end_date": "2020-09-01",
  "id": 7,
  "location": {
      "id": 770,
      "name": "Corozal"
  },
  "start_date": "2020-09-01"
}
```
