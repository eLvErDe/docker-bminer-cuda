# nvidia-docker image for bminer's CUDA Zcash/Zclassic (Equihash) miner

This image build [bminer's equihash miner] from its website.
It requires a CUDA compatible docker implementation so you should probably go
for [nvidia-docker].
It has also been tested successfully on [Mesos].

## Build images

```
git clone https://github.com/eLvErDe/docker-bminer-cuda
cd docker-bminer-cuda
docker build -t bminer-cuda .
```

## Publish it somewhere

```
docker tag bminer-cuda docker.domain.com/mining/bminer-cuda:latest
docker push docker.domain.com/mining/bminer-cuda:latest
```

## Test it (using dockerhub published image)

```
nvidia-docker pull acecile/bminer-cuda
nvidia-docker run -it --rm acecile/bminer-cuda /root/bminer --help
```

An example command line to mine using miningpoolhub.com on Zclassic (on my account, you can use it to actually mine something for real if you haven't choose your pool yet):
Check bminer's [examples] for escaping special caracters in URI or other options.
```
nvidia-docker run -it --rm --name bminer-cuda acecile/bminer-cuda /root/bminer -uri stratum://acecile.catchall:x@europe.equihash-hub.miningpoolhub.com:20575 -api 0.0.0.0:4068
```

To mine Bitcoin Gold (Equihash 144):

```
nvidia-docker run -it --rm --name bminer-cuda acecile/bminer-cuda /root/bminer -uri equihash1445://acecile.catchall:x@europe.equihash-hub.miningpoolhub.com:20595 -api 0.0.0.0:4068 -pers BgoldPoW
```

Change -pers to the following value (depending on target coin):

|     Coin    |   -pers  |
|-------------|----------|
|  BitcoinZ   | BitcoinZ |
|  Safe Coin  | Safecoin |
|   ZelCash   | ZelProof |
|   SnowGem   | sngemPoW |
| BitcoinGold | BgoldPoW |


Ouput will looks like:
```
[INFO] [2018-08-29T20:59:05Z] Bminer: When Crypto-mining Made Fast (v10.2.0-c698b5f) 
[INFO] [2018-08-29T20:59:05Z] Checking updates                             
[INFO] [2018-08-29T20:59:05Z] Watchdog has started.                        
[INFO] [2018-08-29T20:59:06Z] Connected to europe.equihash-hub.miningpoolhub.com:20595 
[INFO] [2018-08-29T20:59:06Z] Starting miner on devices [0]                
[INFO] [2018-08-29T20:59:06Z] Starting the management API at 0.0.0.0:4068  
[INFO] [2018-08-29T20:59:06Z] Subscribed to stratum server                 
[INFO] [2018-08-29T20:59:06Z] Set nonce to 060013fb                        
[INFO] [2018-08-29T20:59:06Z] Set target to 000000000000000000000000000000000000000000000080a70d74da40a70d00 
[INFO] [2018-08-29T20:59:06Z] Received new job 8571                        
[INFO] [2018-08-29T20:59:06Z] Authorized                                   
[INFO] [2018-08-29T20:59:06Z] Starting miner on device 0...                
[INFO] [2018-08-29T20:59:06Z] Started miner on device 0                    
[INFO] [2018-08-29T20:59:28Z] Received new job 8572                        
[INFO] [2018-08-29T20:59:36Z] [GPU 0] Speed: 52.60 Sol/s 29.20 Nonce/s Temp: 66C Fan: 51% Power: 182W 0.29 Sol/J 
[INFO] [2018-08-29T20:59:37Z] Total 52.60 Sol/s 29.20 Nonce/s Accepted shares 0 Rejected shares 0 
[INFO] [2018-08-29T20:59:38Z] Accepted share #5                            
[INFO] [2018-08-29T21:00:06Z] [GPU 0] Speed: 57.84 Sol/s 29.18 Nonce/s Temp: 66C Fan: 51% Power: 198W 0.29 Sol/J 
[INFO] [2018-08-29T21:00:07Z] Total 57.84 Sol/s 29.18 Nonce/s Accepted shares 1 Rejected shares 0 
```

## Background job running forever

```
nvidia-docker run -dt --restart=unless-stopped -p 4068:4068 --name bminer-cuda acecile/bminer-cuda /root/bminer -uri stratum://acecile.catchall:x@europe.equihash-hub.miningpoolhub.com:20575 -api 0.0.0.0:4068
```

You can check the output using `docker logs bminer-cuda -f`


## Use it with Mesos/Marathon

Edit `mesos_marathon.json` to replace Zcash/Zclassic mining pool parameter, change application path as well as docker image address (if you dont want to use public docker image provided).
Then simply run (adapt application name here too):

```
curl -X PUT -u marathon\_username:marathon\_password --header 'Content-Type: application/json' "http://marathon.domain.com:8080/v2/apps/mining/bminer-cuda?force=true" -d@./mesos\_marathon.json
```

You can check CUDA usage on the mesos slave (executor host) by running `nvidia-smi` there:

```
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 384.130                Driver Version: 384.130                   |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|===============================+======================+======================|
|   0  GeForce GTX 108...  On   | 00000000:82:00.0 Off |                  N/A |
| 51%   67C    P2   192W / 195W |   2623MiB / 11172MiB |    100%      Default |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                       GPU Memory |
|  GPU       PID   Type   Process name                             Usage      |
|=============================================================================|
|    0     27469      C   /root/bminer                                2612MiB |
+-----------------------------------------------------------------------------+
```

[bminer's equihash miner]: https://www.bminer.me
[nvidia-docker]: https://github.com/NVIDIA/nvidia-docker
[Mesos]: http://mesos.apache.org/documentation/latest/gpu-support/
[example]: https://www.bminer.me/examples/
