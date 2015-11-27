CTF-ENGINE!
============

This project is beta version.

Usage
-----

Clone this repository.

	git clone https://github.com/btamburi/ctf-engine.git

After changes to the files, build the container.

	docker build -t ctf/engine .


Parameters
-----

	SERVER_NAME      IP container or domain for configuration Apache (ServerName).
	EMAIL_ADM      	 E-mail the web administrator.


Running
-----

After building the container, run. Remember to put the `SERVER_NAME` and `EMAIL_ADM` parameters.

	docker run -d -p 80:80 --env SERVER_NAME=ctf.yourdomain.com --env EMAIL_ADM=your@mail.com ctf/engine


Resources
-----

* [Mellivora][engine]
* [LAMP][lamp]


Copyright
-----

All rights reserved developers of applications base.


[engine]: https://github.com/Nakiami/mellivora
[lamp]: https://github.com/tutumcloud/lamp