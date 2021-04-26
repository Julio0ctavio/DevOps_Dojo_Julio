If you want to use Ansible with Python3, follow the next steps:

1. Install python3 whatever version -> https://docs.python-guide.org/starting/install3/linux/

2. Update the pip3 package-management system:
    $ pip3 install --upgrade pip
    $ pip3 install ansible
    $ ansible --version | grep "python version (Verifies if ansible is using python3.x)
    * For more details about Python3 support: https://docs.ansible.com/ansible/latest/reference_appendices/python_3_support.html

3. Add your hosts (instances) into the hosts file:
  $ sudo nano /etc/ansible/hosts
  * On your hosts file:
      [hosts]
      client1@ubuntuc1.local
      client2@ubuntuc2.local
      client3@ubuntuc3.local

      [hosts:vars]
      ansible_python_interpreter=/usr/bin/python3.x

4. For Ansible Playbooks:
    $ cd /etc/ansible
    $ mkdir Playbooks
    $ cd Playbooks
    $ nano my first_playbook.yml

    * Before running any playbook, please add the following command line into
    /etc/ansible/ansible.conf, if you have already copied the ssh-id on each vm,
    you must indicate where your private key is on your host:

        [defaults]
        private-key = PATH

    $ ansible-playbook -i /etc/ansible/hosts /etc/ansible/Playbooks/first_playbook.yml
