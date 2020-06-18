FCM=$1
curl -i -H 'Content-type: application/json' -H 'Authorization: key=AAAAd5ozHks:APA91bEsfn2CGu9pjksI7edC44el9KDoc7CJhdMiPzVVQLtqAL70d9OxlZOyKrEN5S216zljcmMGbS-MyWoD0lDhDPd9q6nsI7Pqt2yT90VK3yM0XWIXDQvAkVZXsWt1WcI1flaRR6_Q' -XPOST https://fcm.googleapis.com/fcm/send -d '{
  "registration_ids": ["'${FCM}'"],
  "notification" : { 
    "title": "Title",
    "body": "Forms body"
  },
  "data": {
    "id": "1",
    "number": "14"
  }
}'