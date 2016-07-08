#!/bin/bash
set -e

cp leofs_concourse/ansible/deploy_leofs.yml leofs_ansible/
cp leofs_concourse/ansible/roles/leo_manager_0/defaults/main.yml leofs_ansible/roles/leo_manager_0/defaults/

echo $ANSIBLE_KEY > ansible_key
sed -i -e 's/ /\n/g; s/BEGIN\nRSA\nPRIVATE\nKEY/BEGIN RSA PRIVATE KEY/g; s/END\nRSA\nPRIVATE\nKEY/END RSA PRIVATE KEY/g' ansible_key
chmod 600 ansible_key

ansible-playbook -i $ANSIBLE_INVENTORY -b -u leofs --private-key=ansible_key leofs_ansible/purge_leofs.yml
#ansible-playbook -i ../$ANSIBLE_INVENTORY build_leofs.yml
ansible-playbook -i $ANSIBLE_INVENTORY -b -u leofs --private-key=ansible_key leofs_ansible/deploy_leofs.yml

./leofs-adm status
./leofs-adm add-endpoint $LEOFS_GW_HOST
sleep 5
./leofs-adm add-endpoint $LEOFS_GW_HOST

./leofs-adm add-bucket test 05236
