# XD8TA.com

## Overview
XD8TA.com is a web application that allows users to interact with a Language Model (LLM) to analyze and interact with user posts on a social media platform. The website is built using Ruby on Rails and integrates with the X API and OpenAI API to provide various functionalities.

![image](https://github.com/user-attachments/assets/485175ed-ccf1-463a-9e79-881e78191a44)
![image](https://github.com/user-attachments/assets/e8c6d5fa-089b-40ff-abf1-914d26abde60)


## Features
- **Chat with an LLM**: Users can chat with a Language Model to analyze any X user's last 100 posts (limited by API fetch).
- **Performance Metrics Analysis**: Users can request the LLM to draw an analysis on different performance metrics for a user's posts.
- **Write Posts as a User**: Users can write a post in the words of a user.
- **Chat with Own Posts**: Users can interact with their own posts through the LLM.
- **View Post Analytics**: All post analytics are displayed in a sorted table for easy access.
- **Access Exclusive Information**: Users can access information about a user post that is only available through the X API and not on the X website.

## APIs Used
- **X API**: Used to fetch user posts and related information.
- **OpenAI API**: Integrated for language processing and analysis.
- **Cohere and Anthropic**: Experimented with other LLM APIs, but found that OpenAI provided better performance, especially with large token inputs.

## Installation
To run the XD8TA.com website locally, follow these steps:
1. Clone the repository from GitHub.
2. Install Ruby on Rails if not already installed.
3. Set up API keys for X API and OpenAI API.
4. Configure the necessary environment variables.
5. Run `bundle install` to install dependencies.
6. Run `rails db:migrate` to set up the database.
7. Start the Rails server using `rails server`.
