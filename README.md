# Linux-join-Windows-AD
## Usage
Before using the script you need to set the following variables inside the join-ad.sh
The Script is going to ask for your password during the run process.

Variable | Usage
------------ | -------------
Username | Specify the User you want to use to join the AD
Domain | Specify the Domainname
GROUPS | Space seperated list which groups are allowed to connect via SSH
USER | Space seperated list which user are allowed to connect via SSH
SUDOGROUP | User inside this group are automatically granted sudo priviliges



## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.
