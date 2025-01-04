ARG BUILD_FROM                                                                      
FROM $BUILD_FROM as builder                                                         
                                                                                    
RUN apk add --no-cache git go                                                       
                                                                                    
# install, patch and build Tesla vehicle-command                                    
RUN rm -rf /vehicle-command                                                         
RUN rm -rf /tesla-ble                                                               
RUN git clone https://github.com/teslamotors/vehicle-command.git /vehicle-command   
                                                                                    
# apply patch                                                                       
COPY app/patches/vehicle-command/device_linux.go /vehicle-command/pkg/connector/ble/
                                                                                    
WORKDIR /vehicle-command                                                               
RUN go get ./... && \                                       
  go build ./... && \                                       
  go install ./...                                          
                                                            
FROM $BUILD_FROM                                            
COPY --from=builder /root/go/bin/tesla-control /root/go/bin/
COPY app /root/go/bin/tesla-ble                             
# temporary fix for config file                             
COPY app/tesla-ble.conf /root/go/bin/                       
                                                            
# install dependencies                                      
RUN apk add --no-cache \                              
  openssh \                                                  
  bluez \                                                    
  bluez-deprecated                                           
                                                             
# empty root password                                        
RUN echo "root:" | chpasswd                                  
                                                             
# enable ssh with empty password                             
RUN echo "Port 2222" >> /etc/ssh/sshd_config                 
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config       
RUN echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config           
RUN echo "PermitEmptyPasswords yes" >> /etc/ssh/sshd_config             
                                                                        
# generate the keys                                                     
RUN ssh-keygen -A                                                       
                                                                        
#COPY /run.sh /                                                         
#RUN chmod a+x /run.sh                                       
COPY libproduct.sh /app/                                     
                                                             
COPY /start.sh /                                             
#RUN sed -i 's|#!/bin/ash.*|#!/command/with-contenv bashio|' /app/run.sh
RUN chmod a+x /start.sh                                                 
RUN sed -i 's|#!/bin/ash.*|#!/command/with-contenv bashio|' /start.sh   
                                                                        
#ENTRYPOINT [ "/start.sh" ]                                             
#CMD [ "/usr/sbin/sshd", "-D" ]                                         
CMD [ "/start.sh" ]              

