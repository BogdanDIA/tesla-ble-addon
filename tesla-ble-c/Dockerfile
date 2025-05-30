ARG BUILD_FROM                                                                      
FROM $BUILD_FROM as builder                                                         
                                                                                    
RUN apk add --no-cache git go                                                       
                                                                                    
# install, patch and build Tesla vehicle-command                                    
RUN rm -rf /vehicle-command                                                         
RUN rm -rf /tesla-ble                                                               
RUN git clone https://github.com/teslamotors/vehicle-command.git /vehicle-command   
RUN cd /vehicle-command && git reset --hard 518091bf4cbcfa1ca6545ba5976a2015d5ba8f73
                                                                                    
# apply patch                                                                       
COPY app/patches/vehicle-command/device_linux.go /vehicle-command/pkg/connector/ble/
                                                                                    
WORKDIR /vehicle-command                                                               
RUN go get ./... && \                                       
  go build ./... && \                                       
  go install ./...                                          
                                                            
FROM $BUILD_FROM                                            
COPY --from=builder /root/go/bin/tesla-control /root/go/bin/
COPY app /root/go/bin/tesla-ble                             
                                                            
# install dependencies                                      
RUN apk add --no-cache \                              
  openssh \                                                  
  bluez \                                                    
  bluez-deprecated                                           
                                                             
# set-up sshd config
RUN echo "Port 2222" >> /etc/ssh/sshd_config                 
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config       
RUN echo "PasswordAuthentication no" >> /etc/ssh/sshd_config           
RUN echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config           
                                                                        
# generate the keys                                                     
RUN ssh-keygen -A                                                       
                                                                        
COPY libproduct.sh /app/                                     
COPY log-debug.sh /root/go/bin/
RUN chmod a+x /root/go/bin/log-debug.sh

RUN mkdir /root/.ssh
RUN chmod 700 /root/.ssh
RUN touch /root/.ssh/authorized_keys
RUN chmod 700 /root/.ssh/authorized_keys
                                                             
COPY /start.sh /                                             
RUN chmod a+x /start.sh                                                 
RUN sed -i 's|#!/bin/ash.*|#!/command/with-contenv bashio|' /start.sh   
                                                                        
#ENTRYPOINT [ "/start.sh" ]                                             
#CMD [ "/usr/sbin/sshd", "-D" ]                                         
CMD [ "/start.sh" ]              

