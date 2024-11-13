<a id="readme-top"></a>

Unified
==================

<!-- PROJECT LOGO -->
<br />
<div align="center">
<h3 align="center">Unified</h3>

  <p align="center">
    A user-friendly and customizeable unified web application for coaching, quality assurance, ticketing and monitoring, etc.
    <br />
      <strong>Explore the docs »</strong>
    <br />
    <br />
    <a href="https://youtu.be/oZ_M5ByqM3M">View Demo (Incomplete)</a>
    ·
    <a href="https://github.com/danrayfr/unified/issues">Report Bug</a>
    ·
    <a href="https://github.com/danrayfr/unified/issues">Request Feature</a>
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
    <li><a href="#usage">Usage</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->
## About The Project

[![Product Name Screen Shot][product-screenshot]](https://www.youtube.com/watch?v=ZSmCFUZnvMc)

Unified is a user-friendly and customizeable web application build with Rails framework. The goal is to used it as an internal tools for coaching, quality assurance, ticketing and monitoring, calendar, and more.

The following are features completed:

<details>
  <summary>Features</summary>
  <ul>
    <li>Coaching framework</li>
    <li>Quality Assurance framework</li>
    <li>Emailing services and notifications</li>
    <li>Ticket and monitoring</li>
    <li>Account management system</li>
    <li>User authentication, and more.</li>
  <ul>
</details>

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Built With

* Ruby on Rails 7.1.3.2
* Ruby 3.3.0
* Tailwind CSS
* Stimulus JS

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- GETTING STARTED -->
## Getting Started

The following are the prerequisites and guides on how you can use this
project:

### Prerequisites

This project requires:

- Ruby 3.3.0, preferably managed using [rbenv] or [asdf][]
- Chromedriver for Capybara testing
- PostgreSQL must be installed and accepting connections
- [Redis][] must be installed and running on localhost with the default port

On a Mac, you can obtain all of the above packages using [Homebrew][].

If you need help setting up a Ruby development environment, check out this [Rails OS X Setup Guide](https://gorails.com/setup/macos/13-ventura), make sure you check the version of your device.

## Getting Started

To get started with the app, clone the repo and then install the needed gems:

```
$ gem install bundler -v 2.5.6
$ bundle _2.5.6_ config set --local without 'production'
$ bundle _2.5.6_ install
```

Create the database :

```
$ rails db:create
```

Next, migrate the database:

```
$ rails db:migrate

$ rails db:seed # optional
```

Finally, run the test suite to verify that everything is working correctly:

```
$ rails test
```

If the test suite passes, you'll be ready to run the app in a local server:

```
$ rails server or bin/dev
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Usage

You can use and adapt and improve the idea of how we think a more user-friendly and customizeable coaching, quality assurance, ticket and monitoring integrated to a service delivery and account management. I, Dan Ray Rollan belives that the idea and process has benefit and impact on how we can build an efficient internal tools.

<p align="right">(<a href="#readme-top">back to top</a>)</p>


## License

Distributed under the MIT License.

MIT License

Copyright (c) 2024 Dan Ray Rollan

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Contact

Dan Ray Rollan - [@instagram/danrayfr](https://www.instagram.com/danray_fr/) - danrayrollan98@gmail.com

Github Profile: [https://github.com/danrayfr/](https://github.com/danrayfr/)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

Many thanks to Supportninja Service Delivery team for allowing me to share the idea and process on how we can improve the tools we're using.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->
[product-screenshot]: ./app/assets/images/documentations/unified.png
