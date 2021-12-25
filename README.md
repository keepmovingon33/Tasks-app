# Tasks-app
Build a tasks app using Firebase

- When run the app, if the user is not logged in, it will transit the user to onboarding screen:

![Simulator Screen Shot - iPhone 11 - 2021-12-25 at 02 39 21](https://user-images.githubusercontent.com/41308004/147380132-1b38e095-399a-479c-a8cf-c37e2c59f813.png)

- When user is not logged and is at onboarding screen, tapping on "Get Started" button will transit user to this login screen. Used Firebase to handle auth login/signup. Used Framework `MBProgressHUD` to handle the loading indicator. Used Framework `Loaf` to handle displaying error message

![Simulator Screen Shot - iPhone 11 - 2021-12-25 at 02 39 52](https://user-images.githubusercontent.com/41308004/147380153-57c08150-7b7d-49d8-8c6d-8fc671978dc4.png)

- When the user is signup/login successfully, or when we first run the app and the user is still logged in, it will transit to the tasks screen. It will list out all the tasks of that user. And these tasks will be distinguished with different users. And these tasks was display dynamically from Firebase

![Simulator Screen Shot - iPhone 11 - 2021-12-25 at 02 47 02](https://user-images.githubusercontent.com/41308004/147380267-07731758-5c68-47ee-8a7b-3de3ddba514d.png)

- When user tap on the circle button for each task, it will be move to Done screen. And if user tap on the task on done screen, that task will be moved back to ongoing task screen. All those tasks displayed in both Done screen and Ongoing screen are dynamically from Firebase

![Simulator Screen Shot - iPhone 11 - 2021-12-25 at 02 47 46](https://user-images.githubusercontent.com/41308004/147380338-b5ba043e-159a-46b3-a1e8-cadcdc3e2c64.png)

- When user tap on the plus button, it will lead to new task screen, so that user could add new task with deadline in this screen. The new task will be updated on Firebase

![Simulator Screen Shot - iPhone 11 - 2021-12-25 at 02 52 26](https://user-images.githubusercontent.com/41308004/147380320-95ec6aa7-f1eb-4a4a-913c-13d4b4d923c3.png)

- User could edit or delete the task if they want
![Simulator Screen Shot - iPhone 11 - 2021-12-25 at 02 47 28](https://user-images.githubusercontent.com/41308004/147380350-d695901c-417c-42bf-8b47-7fdedd45896a.png)

- User could logout and it will transit the user back to onboarding screen

![Simulator Screen Shot - iPhone 11 - 2021-12-25 at 02 47 57](https://user-images.githubusercontent.com/41308004/147380362-2b513f0f-6709-4873-9db4-7ecc8fca95e1.png)

