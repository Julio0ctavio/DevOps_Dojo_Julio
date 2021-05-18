# If you want to use Ansible with Python3, follow the next steps:

    1. Install python3 whatever version -> https://docs.python-guide.org/starting/install3/linux/

    2. Update the pip3 package-management system:
        $ pip3 install --upgrade pip
        $ pip3 install ansible
        $ ansible --version | grep "python version (Verifies if ansible is using python3.x)
        For more details about Python3 support: https://docs.ansible.com/ansible/latest/reference_appendices/python_3_support.html

    3. Add your hosts (instances) into the hosts file:

        $ sudo nano /etc/ansible/hosts
        On your hosts file:
        [hosts]
        client1@ubuntuc1.local
        client2@ubuntuc2.local
        client3@ubuntuc3.local

        [hosts:vars]
        ansible_python_interpreter=/usr/bin/python3.x

# For Ansible Playbooks:

    $ cd /etc/ansible
    $ mkdir Playbooks
    $ cd Playbooks
    $ nano my first_playbook.yml

    * Before running any playbook, please add the following command line into
    /etc/ansible/ansible.cfg, if you have already copied the ssh-id on each vm,
    you must indicate where your private key is on your host:

        [defaults]
        private-key = PATH

    $ ansible-playbook -i /etc/ansible/hosts /etc/ansible/Playbooks/first_playbook.yml

# For Wordpress & MySQL configuration after playbook execution.

    How to configure PHP properly:

    $ cd /etc/php/7.2/fpm/pool.d
    $ sudo nano www.conf 

    Write the following line:
    listen = 127.0.0.1:9001

    $ systemctl restart php7.2-fpm 

    How To Allow Remote Access to MySQL:

    To enable this, open up your mysqld.cnf file:
    $ sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf

    By default, this value is set to 127.0.0.1, 
    meaning that the server will only look for local connections. 
    For the purposes of troubleshooting, 
    you could set this directive to a wildcard IP address, either *, ::, or 0.0.0.0:

    lc-messages-dir = /usr/share/mysql
    skip-external-locking
    
    Instead of skip-networking the default is now to listen only on
    localhost which is more compatible and is not less secure.
    bind-address            = 0.0.0.0

    After changing this line, save and close the file (CTRL + X, Y, then ENTER if you edited it with nano).

    Log in mysql service as a root user:
    $ mysql -u root -p

    Once inside, you must let the user(for WordPress DB) be able to connect remotely from the frontend server:
    mysql> SELECT host, user from mysql.user;
    
    To change a user’s host, you can use MySQL’s RENAME USER command. Run the following command, making sure to change sammy to the name of your MySQL user account and remote_server_ip to your remote server’s IP address:
    mysql> RENAME USER 'sammy'@'localhost' TO 'sammy'@'frontend_server_ip';

    Then grant the new user the appropriate privileges for your particular needs.
    mysql> GRANT ALL PRIVILEGES ON wordpress.* TO 'sammy'@'frontend_server_ip';

    Flush the privileges to save any change:
    mysql> FLUSH PRIVILEGES;
    mysql> exit

    Then restart the MySQL service to put the changes you made to mysqld.cnf into effect:
    $ sudo systemctl restart mysql

    If you have set up properly all parameters, you could see a successfully wordpress login page.




