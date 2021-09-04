help:		## Show this help.
	@fgrep -h "##" $(MAKEFILE_LIST) | grep -v fgrep

catalogue:	## Install Catalogue
	@bash components/catalogue.sh
	
mongodb:	## Install Mongodb
	@bash components/mongodb.sh
	
redis:		## Install Redis
	@bash components/redis.sh

user:		## Install User
	@bash components/user.sh

cart:		## Install Cart
	@bash components/cart.sh
	
mysql:		## Install My SQL
	@bash components/mysql.sh
	
shipping:	## Install Shipping
	@bash components/shipping.sh
	
rabbitmq:	## Install Rabbit MQ
	@bash components/rabbitmq.sh
	
payment:	## Install Payment
	@bash components/payment.sh
	
frontend:	## Install Frontend
	@bash components/frontend.sh
	