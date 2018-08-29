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
|  BitcoinZ   | BitcoinZ |
|  Safe Coin  | Safecoin |
|   ZelCash   | ZelProof |
|   SnowGem   | sngemPoW |
| BitcoinGold | BgoldPoW |


Ouput will looks like:
```
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
```

[bminer's equihash miner]: https://www.bminer.me
[nvidia-docker]: https://github.com/NVIDIA/nvidia-docker
[Mesos]: http://mesos.apache.org/documentation/latest/gpu-support/
[example]: https://www.bminer.me/examples/
