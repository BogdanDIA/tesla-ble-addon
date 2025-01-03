ARG BUILD_FROM
FROM $BUILD_FROM as builder

RUN apk add --no-cache git openssh
# empty root password  
RUN echo "root:pass" | chpasswd
RUN echo "Port 2222" >> /etc/ssh/sshd_config
RUN echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
RUN echo "PermitEmptyPasswords yes" >> /etc/ssh/sshd_config

# install, patch and build Tesla vehicle-command
RUN rm -rf /vehicle-command
RUN rm -rf /tesla-ble
RUN git clone https://github.com/teslamotors/vehicle-command.git /vehicle-command
RUN git clone -b ha_addon https://github.com/BogdanDIA/tesla-ble.git /tesla-ble
# apply patch
RUN cp /tesla-ble/patches/vehicle-command/device_linux.go /vehicle-command/pkg/connector/ble/
WORKDIR /vehicle-command
RUN go get ./... && \
  go build ./... && \
  go install ./...

FROM $BUILD_FROM
COPY --from=builder /root/go/bin/tesla-control /root/go/bin/
COPY --from=builder /tesla-ble /root/go/bin/tesla-ble
COPY --from=builder /tesla-ble/tesla-ble.conf /root/go/bin/         
                        
# install dependencies  
RUN apk add --no-cache \
  bluez \         
  bluez-deprecated    

COPY /app/run.sh /app/    
COPY libproduct.sh /app/                         

RUN chmod a+x /app/run.sh                  
RUN sed -i 's|#!/bin/ash.*|#!/command/with-contenv bashio|' /app/run.sh

COPY /start.sh /
RUN chmod a+x /start.sh                  

ENTRYPOINT [ "/start.sh" ]
CMD [ "/usr/sbin/sshd", "-D" ]
