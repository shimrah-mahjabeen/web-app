# Git Insight

This is a test project built with Ruby on Rails that utilizes the GitHub API to fetch repositories, individual repositories, create pull requests, and fetch all branches of a repository. The project also includes GitHub authentication for user access.

## Table of Contents

- Description
- Features
- Prerequisites
- Installation
- Usage
- Configuration
- Testing
- Deployment
- Contributing
- License

### Description

The project aims to provide functionality to interact with the GitHub API for fetching repository information, creating pull requests, and retrieving branch details. It also includes GitHub authentication to ensure secure access to the application.

### Features

- Fetch repositories using the GitHub API
- Retrieve details of an individual repository
- Create pull requests on GitHub repositories
- Fetch all branches of a repository
- GitHub authentication for user access

## Prerequisites

Make sure you have the following prerequisites installed on your local machine:

- Ruby [3.0.0]
- Rails [7.0]
- Docker
- GitHub API credentials (client ID and client secret)

## Installation

1. Clone the repository:

```
git clone https://github.com/afeefazaman/web-app.git
```

2. Navigate to the project directory:

```
cd web-app
```

3. Install the required gems:

```
bundle install
```

4. Set up the database:

```
rails db:create
rails db:migrate
```

## Usage

1. Start the Rails server:

```
rails server
```

2. Open your web browser and navigate to http://localhost:3000.

3. You can now use the application to perform various tasks such as fetching repositories, creating pull requests, and accessing repository details.

## Configuration

The project requires configuration for GitHub API credentials. Follow these steps to set up the configuration:

1. You can directly replace CLIENT_ID and CLIENT_SECRECT in devise.rb for testing purpose or you can keep them in .env file.

2. Or you can manage credentials.yml.enc to keep and get the github creds.

## Testing

The project includes automated tests to ensure the correctness of its functionality. To run the tests, use the following command:

```
bundle exec rspec
```

## Deployment

The project can be deployed to a production environment using Docker. Follow these steps for deployment:

### Prerequisites

- Add your database username and password in docker-compose.yml

1. Build the Docker image:

```
docker-compose build
```

2. Start the containers:

```
docker-compose up
```
