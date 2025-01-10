# Use a lightweight Java image
FROM openjdk:17-jdk-slim

# Set working directory
WORKDIR /server

# Install wget and any required tools
RUN apt-get update && apt-get install -y wget && apt-get clean

# Define Minecraft and Forge version
ENV MINECRAFT_VERSION=1.20.1
ENV FORGE_VERSION=47.3.22

# Download the Forge installer
RUN wget -O forge-installer.jar "https://maven.minecraftforge.net/net/minecraftforge/forge/${MINECRAFT_VERSION}-${FORGE_VERSION}/forge-${MINECRAFT_VERSION}-${FORGE_VERSION}-installer.jar"

# Install Forge server
RUN java -jar forge-installer.jar --installServer && \
    rm forge-installer.jar

# Accept the Minecraft EULA
RUN echo "eula=true" > eula.txt

# Expose the Minecraft server port
EXPOSE 25565

# Start the server dynamically using a shell for variable substitution
CMD java -Xms128M -XX:MaxRAMPercentage=95.0 -Dterminal.jline=false -Dterminal.ansi=true $( [[  ! -f unix_args.txt ]] && printf %s "-jar {{SERVER_JARFILE}}" || printf %s "@unix_args.txt" )
