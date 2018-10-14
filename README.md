# Quorum Development Environment

This repo set up a vagrant virtual machine with quorum, tessera, constellation etc.

### Prerequisite

1. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. Install [Vagrant](https://www.vagrantup.com/downloads.html)
3. Download and start the Vagrant instance (note: running `vagrant up` takes approx 5 mins):

    ```sh
    git clone https://github.com/zzy96/quorum-dev
    cd quorum-dev
    vagrant up
    vagrant ssh
    ```
    
4. To shutdown the Vagrant instance, run `vagrant suspend`. To delete it, run
   `vagrant destroy`. To start from scratch, run `vagrant up` after destroying the
   instance.
   
### Build the resources

1. Inside Vagrant go to quorum directory.

    ```sh
    cd quorum
    ```
    
2. Build all quorum components.
  
    ```sh
    make all
    ```
    
### Running the 7nodes example

Shell scripts are included in the examples to make it simple to configure the network and start submitting transactions.

All logs and temporary data are written to the `qdata` folder.

#### Using Raft consensus

1. Navigate to the 7nodes example, configure the Quorum nodes and initialize accounts & keystores:
    ```sh
    cd 7nodes
    ./raft-init.sh
    ```
2. Start the Quorum and privacy manager nodes (Constellation or Tessera):
    - If running in Vagrant:
        ```sh
        ./raft-start.sh
        ```
        By default, Constellation will be used as the privacy manager.  To use Tessera run the following:
        ```
        ./raft-start.sh tessera
        ```
        By default, `raft-start.sh` will look in `/home/vagrant/tessera/tessera-app/target/tessera-app-{version}-app.jar` for the Tessera jar.
    
    - If running locally with Tessera:
        ```
        ./raft-start.sh tessera --tesseraOptions "--tesseraJar /path/to/tessera-app.jar"
        ``` 
    
        The Tessera jar location can also be specified by setting the environment variable `TESSERA_JAR`.
    
3. You are now ready to start sending private/public transactions between the nodes.

#### Using Istanbul BFT consensus

To run the example using __Istanbul BFT__ consensus use the corresponding commands:
```sh
istanbul-init.sh
istanbul-start.sh
istanbul-start.sh tessera
stop.sh
```

### Next steps: Sending transactions
Some simple transaction contracts are included in quorum-examples to demonstrate the privacy features of Quorum.  To learn how to use them see the [7nodes README](examples/7nodes/README.md).

### Web UI

1. Add identity flag to the geth command inside `istanbul-start.sh` and `raft-start.sh`, WS_SECRET environment variable is set to '123' during the set up.

  ```sh
  --identity node1 --ethstats "node1:123@localhost:3000"
  ```

2. Start web server inside `eth-netstats`.
  
  ```sh
  cd eth-netstats
  npm start
  ```
