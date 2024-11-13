terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"  
}
resource "aws_instance" "wordpress" {
  ami                    = "ami-0ddc798b3f1a5117e"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.id
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    # Update and install necessary packages
    sudo apt-get update -y
    sudo apt-get install -y apache2 php php-mysql mysql-client wget unzip

    cd /tmp
    wget https://wordpress.org/latest.zip
    unzip latest.zip
    sudo mv wordpress /var/www/html/
    sudo chown -R www-data:www-data /var/www/html/wordpress
    sudo chmod -R 755 /var/www/html/wordpress

    # Configure Apache
    sudo tee /etc/apache2/sites-available/wordpress.conf > /dev/null <<EOL
    <VirtualHost *:80>
        DocumentRoot /var/www/html/wordpress
        <Directory /var/www/html/wordpress>
            AllowOverride All
            Require all granted
        </Directory>
    </VirtualHost>
    EOL

    sudo a2enmod rewrite
    sudo a2ensite wordpress
    sudo systemctl restart apache2

  EOF

  tags = {
    Name = "WordPress-Instance"
  }
}