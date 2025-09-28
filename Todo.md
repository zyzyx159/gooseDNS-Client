``` YAML
version: '3.8'

services:
  my_service:
    image: my_image
    volumes:
      - ./startup.sh:/startup.sh
    post_start:
      - command: ["sh", "-c", "/startup.sh"]   
```
``` BASH
#!/bin/bash 
echo "Starting setup..." 
# Perform initialization tasks 
python3 -m http.server 8080 & 
echo "Setup complete."
```