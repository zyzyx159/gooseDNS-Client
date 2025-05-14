import requests
import yaml
import os
import subprocess
import logging
import paramiko
from scp import SCPClient

def processIP(response):
    responseList = response.text.splitlines()
    remoteAddr = responseList[4]
    ipList = remoteAddr.split(":")
    ipAddr = ipList[1]
    ipAddr = ipAddr.strip()
    return ipAddr

def compareIP(currentIP, settingsDict):
    if currentIP != settingsDict["wanIP"]:
        settingsDict["wanIP"] = currentIP
        update(settingsDict)
        pushUpdate(settingsDict)

def update(settingsDict):
    with open(settingsFile, 'w') as file:
        yaml.dump(settingsDict, file)
    # print("update")

def pushUpdate(settingsDict):
    with paramiko.SSHClient() as ssh:
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

        try:
            # Load the SSH agent
            agent = paramiko.Agent()
            keys = agent.get_keys()

            if not keys:
                raise Exception("No keys found in SSH agent")

            # Try each key in the agent
            for key in keys:
                try:
                    ssh.connect(hostname=settingsDict['host'], username=settingsDict['userName'], pkey=key, timeout=30)
                    break
                except paramiko.AuthenticationException:
                    continue
            else:
                raise Exception("No key worked for authentication")

            # # Initialize the SCP client
            # with SCPClient(ssh.get_transport()) as scp:
            #     # Upload a file from local to remote
            #     local_file = 'settings.yml'
            #     remote_file = settingsDict['output']
            #     scp.put(local_file, remote_file)
            #     print(f"File {local_file} uploaded successfully to {remote_file}")

            # Open an SFTP session
            sftp = ssh.open_sftp()

            # Transfer the file
            sftp.put('settings.yml', settingsDict['output'])

            # Close the SFTP session and the SSH connection
            sftp.close()
            ssh.close()

        except Exception as e:
            print("An error occurred:", e)
        finally:
            print("Connection closed")

settingsFile = os.path.join(os.getcwd(), "settings.yml")
with open(settingsFile, 'r') as file:
    settingsDict = yaml.safe_load(file)
    currentIP = processIP(requests.get(settingsDict["sourceURL"]))
    compareIP(currentIP, settingsDict)

# Generate ssh key
# add key to server
# make sure key is added to agent