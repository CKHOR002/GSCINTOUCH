<div id="top"></div>

<!-- PROJECT SHIELDS -->
<!-- [![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![LinkedIn][linkedin-shield]][linkedin-url]
 -->

<!-- PROJECT LOGO -->
<br />
<div align="center">


  <h3 align="center">InTouch</h3>

  <p align="center">
    Mental Health Application!
    <br />
    <br />
    <a href="https://github.com/CKHOR002/GSCINTOUCH">View Demo</a>
    ·
    <a href="https://github.com/CKHOR002/GSCINTOUCH/issues">Report Bug</a>
    ·
    <a href="https://github.com/CKHOR002/GSCINTOUCH/issues">Request Feature</a>
  </p>
  <p align="center">
    Greatly appreciate contributions from <a href="https://github.com/jingshenggg">@jingshenggg</a>, <a href="https://github.com/zhenyong25">@zhenyong25</a>, <a href="https://github.com/CKHOR002">@CKHOR002</a> and <a href="https://github.com/jiawei99">@jiawei99</a>
  </p>
  </p>
</div>



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

<!-- [![Product Name Screen Shot][product-screenshot]](https://example.com) -->


InTouch is a mobile application aimed at improving mental health. It allows users to access psychological first aid courses and provides a platform for users to receive consultations from trained befrienders or psychological first aiders.

We aim to offer an APP to have the following features:
*Video and voice consultation feature for users with mental health issues
*Text diary feature for users to record their daily experiences and emotions
*Sentiment analysis feature to provide users with feedback on their diary entries
*Reward system for users to earn points and redeem them for vouchers
*Psychological first aid courses for befrienders to improve their ability to assist individuals with mental health issues
*Scenario-based quizzes with GPT3 Turbo API analysis for befriender skill validation
*Consultation feature for qualified psychological first aiders to provide assistance to users with mental health issues


<p align="right">(<a href="#top">back to top</a>)</p>


### Built With

Here are major frameworks/libraries used to bootstrap this project.

* [Dart](https://dart.dev/)
* [Flutter](https://flutter.dev/)
* [Firebase](https://firebase.google.com/)

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- GETTING STARTED -->
## Getting Started

Below are instructions on setting up the project locally.

### Prerequisites

This is an example of how to get a local copy up and running.

* For Android Studio and IntelliJ: https://flutter.dev/docs/development/tools/android-studio
* For Visual Studio Code: https://flutter.dev/docs/development/tools/vs-code

### Installation
1. Clone the repo
   ```sh
   git clone https://github.com/CKHOR002/GSCINTOUCH.git
   ```
2. Install packages
   ```sh
   flutter pub get
   ```
   
   
3. Configure .env file

i.Open terminal and navigate to the project folder<br>
ii.Run cp .env.example .env<br>
iii.Fill in the .env file with the details that you have gathered in the following step<br>
iv.Modify .env file in the root of the application by following actions.<br><br><br>

Steps:
OpenAI API Key
1. Go to https://platform.openai.com/overview to sign up or login to open ai account. <br>
2. Go to "Personal" tab on the top right of the page. <br>
3. Select "View API keys" <br>
4. Create a new secret key if you do not have one. <br>
5. Copy your secret key and paste it to the OpenAIAPIKey variable in env file.<br>

Consulation API Key
1. Go to the 100ms.live website and click on the "Sign up" button at the top right corner of the page.<br>
2. Fill out the registration form with your email address and password. You can also sign up using your Google or Github account.<br>
3. Once you have signed up and logged in, you will be redirected to the dashboard. From there, click on the "Create new room" button.<br>
4. Select ‘Video Conferencing’ as the template.<br>
5. After successful creation, you can go to Developer sections through the navigation bar.<br>
6. You can find  a App Access Key and a App Secret.<br>
7. Copy your App Access Key and App Secret Key and paste them to the 100msAppAccessKey and 100msAppSecret variable respectively in .env file.<br><br>

Google Cloud Platform API Key
1. Log in to the Google Cloud Console (https://console.cloud.google.com/).<br>
2. Select the project for which you want to create the service account from the drop-down menu at the top of the page.<br>
3. Click on the "IAM & Admin" menu from the left-hand side of the page.<br>
4. Select "Service accounts" from the sub-menu.<br>
5.Click on the "Create service account" button at the top of the page.<br>
6. Enter a name for the service account, and optionally, a description.<br>
7. Select the appropriate role for the service account from the "Role" drop-down menu. If you are not sure which role to choose, you can select "Project" and "Editor" to give the service account full access to the project.<br>
8. Click on the "Create" button.<br>
9. Once the service account is created, click on the "Create key" button in the "Keys" tab.<br>
10. Select the "JSON" format and click on the "Create" button.<br>
11. A JSON file containing the API key will be downloaded to your computer. This file contains the private key that you will need to authenticate with the Google Cloud APIs.
<br><br>
		{<br>
		 "type": "service_account",<br>
		 "project_id": "",<br>
		 "private_key_id": "COPY THE PrivateKeyID FROMHERE",<br>
		 "private_key": "COPY THE PrivateKEY FROM HERE",<br>
		 "client_email": "audiototext@intouch-378205.iam.gserviceaccount.com",<br>
		 "client_id": "112907106975140504099",<br>
		 "auth_uri": "https://accounts.google.com/o/oauth2/auth",<br>
		 "token_uri": "https://oauth2.googleapis.com/token",<br>
		 "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",<br>
		 "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/audiototext%40intouch-<br>378205.iam.gserviceaccount.com"<br>
		}<br>
12. Copy the private key from the private_key_id field and private_key in the JSON above and paste it into APPACCESSKEY and APPSECRET variable in .env.


 

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- CONTACT -->
## Contact

Khor Chin Yi - cykhor11@gmail.com

Project Link: [https://github.com/CKHOR002/GSCINTOUCH](https://github.com/CKHOR002/GSCINTOUCH)

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

* [Flutter Documentation](https://flutter.dev/docs/development/tools/vs-code)
* [Get to know Firebase for Flutter](https://firebase.google.com/codelabs/firebase-get-to-know-flutter#0)


<p align="right">(<a href="#top">back to top</a>)</p>



