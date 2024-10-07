# Usar la imagen oficial de Keycloak como base
FROM quay.io/keycloak/keycloak:25.0.1
# Configuraciones para Mailgun
ENV JAVA_OPTS="-Djboss.mail.smtp.host=smtp.mailgun.org \
               -Djboss.mail.smtp.port=587 \
               -Djboss.mail.smtp.starttls.enable=true \
               -Djboss.mail.smtp.auth=true"
# Copiar la configuración del realm y el script de health check
COPY realm-config /opt/keycloak/data/import/
COPY keycloak-db /opt/jboss/keycloak/standalone/data
# Exponer los puertos que usa la aplicación
EXPOSE 8080 
# Comando de inicio
ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start", "--import-realm"]
