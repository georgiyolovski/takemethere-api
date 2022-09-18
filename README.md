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

### Get Search Session

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

### Get Flight Tickets

#### Headers
`Authorization: {token here}`

*GET* `/api/search_sessions/1/flights`

#### Response
```json
{
    "outgoing": [
        {
            "legs": [
                {
                    "arrival_time": "2022-10-10T20:55:00+02:00",
                    "carrier": {
                        "logo": "https://static.tacdn.com/img2/flights/airlines/logos/100x100/WizzAir.png",
                        "name": "Wizzair"
                    },
                    "departure": "SOF",
                    "departure_time": "2022-10-10T19:55:00+03:00",
                    "destination": "CIA"
                }
            ],
            "notes": [],
            "price": {
                "amount": 20.0,
                "id": "SkyScanner|1|6",
                "impressionId": "2f5885fb-15df-4dcd-afe6-736c12905c8a.20611"
            },
            "search_hash": "1dd5f2da5692c4ad4b42926eb93b6da9",
            "search_id": "46f9a40f-8b98-4165-afe2-bc51308d3553.342"
        }
    ],
    "return": [
        {
            "legs": [
                {
                    "arrival_time": "2022-10-13T14:20:00+03:00",
                    "carrier": {
                        "logo": "https://static.tacdn.com/img2/flights/airlines/logos/100x100/RyanAir.png",
                        "name": "Ryanair"
                    },
                    "departure": "CIA",
                    "departure_time": "2022-10-13T11:40:00+02:00",
                    "destination": "SOF"
                }
            ],
            "notes": [],
            "price": {
                "amount": 19.0,
                "id": "Kayak|1|46",
                "impressionId": "4556d01d-dee2-416e-ba58-845f7d481127.19713"
            },
            "search_hash": "54a8146d3bbed9739be7733634523cfc",
            "search_id": "ee77a3e7-57d6-4a64-953e-9c760b40503f.357"
        }
    ]
}
```

### Get Booking URL

#### Headers
`Authorization: {token here}`

*GET* `/api/booking_url?search_hash=1dd5f2da5692c4ad4b42926eb93b6da9&destination=CIA&id=SkyScanner|1|6&origin=OFS&search_id=46f9a40f-8b98-4165-afe2-bc51308d3553.342&impression_id=2f5885fb-15df-4dcd-afe6-736c12905c8a.20614`

#### Response
```json
{
    "booking_url": "https://partners.api.skyscanner.net/apiservices/deeplink/v2?_cje=IYEnrlvRxa%2BQ6sTHxjCdCZ2XF%2FNaPsaII5YlCXZ7GYDeLh0tmqWV4z4Fzk2IM6h1&url=https%3A%2F%2Fwww.skyscanner.net%2Ftransport_deeplink%2F4.0%2FRU%2Fru-RU%2FRUB%2Fwizz%2F1%2F16440.10525.2022-10-10%2Fair%2Fairli%2Fflights%3Fitinerary%3Dflight%7C-31669%7C4315%7C16440%7C2022-10-10T19%3A55%7C10525%7C2022-10-10T20%3A55%7C120%7C-%7C-%7CBasic%26carriers%3D-31669%26operators%3D-31669%26passengers%3D1%26channel%3Ddataapi%26cabin_class%3Deconomy%26facilitated%3Dfalse%26fps_session_id%3D2ee9212d-9f55-497c-a27d-7350c26ab3da%26ticket_price%3D1211.16%26is_npt%3Dfalse%26is_multipart%3Dfalse%26client_id%3Dskyscanner_b2b%26request_id%3D8cf929c9-7b6e-4ba6-bf6b-ff605f006721%26q_ids%3DH4sIAAAAAAAAAOOS5mIpz6yqEmLh2NHAKMXMMTdIoeFg7yw2IyYFRgDGoSHcHQAAAA%7C7404238036994044409%7C1%26q_sources%3DJACQUARD%26commercial_filters%3Dfalse%26q_datetime_utc%3D2022-09-17T13%3A24%3A00%26pqid%3Dfalse&auid=090b931b-1688-453e-bb97-95f507f08cc4"
}
```

### Get Tourist Attractions

#### Headers
`Authorization: {token here}`

*GET* `/api/search_sessions/1/places`

#### Response
```json
[
    {
        "id": "ChIJz9cDEQ2jpBIRyPyyZbHXCkA",
        "address": "Barceloneta Beach, Spain",
        "image_url": "https://lh3.googleusercontent.com/places/AM5lPC_R18c11eDCnK_ljRU4tJRQmMW3jK5nGoVZvtcMAPAPU95eYGnhVgibOJVq8VzMKqSldM9Leb6HSf0kt8NOyvD2En2h_spGMw=s1600-w700",
        "location": {
            "lat": 41.3783713,
            "lng": 2.1924685
        },
        "name": "Barceloneta Beach",
        "rating": 4.3,
        "tags": [
            "natural_feature",
            "establishment"
        ]
    },
    {
        "id": "ChIJz9cDEQ2jpBIRyPyyZbHXCkA",
        "address": "Pl. de Catalunya, 1, 4, 08002 Barcelona, Spain",
        "image_url": "https://lh3.googleusercontent.com/places/AM5lPC_rza_XebgjA5T3hbkK6dunULHq8D6FcausyvvL56bHyuWsxcYjhfbzyvGdtVWrwvrlT8hGHJ_DAFNk8OzvJj5JsrXnqyOf2g=s1600-w700",
        "location": {
            "lat": 41.3858752,
            "lng": 2.1691163
        },
        "name": "Centre Comercial El Triangle",
        "rating": 4,
        "tags": [
            "shopping_mall",
            "point_of_interest",
            "store",
            "establishment"
        ]
    }
]
```

### Get User Trips

#### Headers
`Authorization: {token here}`

*GET* `/api/trips`

#### Response
```json
  [
    {
        "activities": [
            "beach",
            "shopping"
        ],
        "adults": 2,
        "children": 0,
        "cover_url": "https://lh3.googleusercontent.com/places/AM5lPC9vvloMeGObbGr1ET9y4wpEFo4sIcLDEoWPQYkvU1_0zECWgC_SBCyv42OjnBPGIfGjHLt6hYDPUUa8-AL0Wl3AZkX9ZM7GtQ=s1600-w700",
        "end_date": "2022-09-15",
        "hotels": {
            "items": []
        },
        "location": {
            "country": "Spain",
            "name": "Barcelona"
        },
        "places": {
            "items": [
                {
                    "address": "Platja de la Nova Icària, Spain",
                    "id": "ChIJz9cDEQ2jpBIRyPyyZbHXCkA",
                    "image_url": "https://lh3.googleusercontent.com/places/AM5lPC9vvloMeGObbGr1ET9y4wpEFo4sIcLDEoWPQYkvU1_0zECWgC_SBCyv42OjnBPGIfGjHLt6hYDPUUa8-AL0Wl3AZkX9ZM7GtQ=s1600-w700",
                    "location": {
                        "lat": 41.3903674,
                        "lng": 2.2023036
                    },
                    "name": "Platja de la Nova Icària",
                    "rating": 4.4,
                    "tags": [
                        "natural_feature",
                        "establishment"
                    ]
                }
            ]
        },
        "start_date": "2022-09-10",
        "tickets": {
            "items": []
        },
        "title": "5 days in Barcelona, Spain"
    }
]
```

### Create a Trip

#### Headers
`Authorization: {token here}`

*POST* `/api/trips`

#### Body
```json
  {
    "search_session_id": 1,
    "tickets": [],
    "hotels": [],
    "places": [{
        "address": "Platja de la Nova Icària, Spain",
        "id": "ChIJz9cDEQ2jpBIRyPyyZbHXCkA",
        "image_url": "https://lh3.googleusercontent.com/places/AM5lPC9vvloMeGObbGr1ET9y4wpEFo4sIcLDEoWPQYkvU1_0zECWgC_SBCyv42OjnBPGIfGjHLt6hYDPUUa8-AL0Wl3AZkX9ZM7GtQ=s1600-w700",
        "location": {
            "lat": 41.3903674,
            "lng": 2.2023036
        },
        "name": "Platja de la Nova Icària",
        "rating": 4.4,
        "tags": [
            "natural_feature",
            "establishment"
        ]
    }]
}
```

#### Response
```json
  %{
    "id" =>
  }
```