# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    start.sh                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: vvaucoul <vvaucoul@student.42.Fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/10/28 16:47:33 by vvaucoul          #+#    #+#              #
#    Updated: 2022/10/28 16:48:37 by vvaucoul         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

if [ -z "$1" ]
then
    echo "No argument supplied"
    exit 1
else
    echo "Starting $1"
    docker build -t $1 . && docker run -it -p 80:80 -p 443:443 $1
fi

# **************************************************************************** #