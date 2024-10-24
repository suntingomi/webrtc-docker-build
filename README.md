# webrtc-docker-build
Docker Environment for Building WebRTC Android Version on Mac with Apple Silicon.

## how to build

1. First build a docker image.

``` bash
docker build --platform linux/amd64 -t webrtc-build:1.0.0 .
```

Pay attention that we should use --platform to specify the architecture.

2. Then run a docker container.

``` bash
docker run --platform linux/amd64 -itd -v /Users/xxx/code/webrtc-android:/webrtc webrtc-build:1.0.0 /bin/bash

# And we should get the container id in terminal: 154229a34c085f779cc7ce190ccfc568b2c96769be899e00793acebd47372aa3
```

The -v option allows you to map a directory from your host machine into the Docker container.

3. Enter docker container

``` bash
docker exec -it 154229a34c085f779cc7ce190ccfc568b2c96769be899e00793acebd47372aa3 /bin/bash

# You can replace repo with your own fork.
gclient config --name src https://github.com/webrtc-sdk/webrtc
```

4. download webrtc source code

If you want to download google webrtc source code, then you can do like this

``` bash
cd /webrtc
fetch --nohooks webrtc_android
gclient sync
```

If you want to use your custom webrtc fork, then maybe you can do like this

``` bash
cd /webrtc
gclient config --name src https://github.com/webrtc-sdk/webrtc
```

then modify .gclient, add target_os item

```
solutions = [
  { "name"        : 'src',
    "url"         : 'https://github.com/webrtc-sdk/webrtc',
    "deps_file"   : 'DEPS',
    "managed"     : True,
    "custom_deps" : {
    },
    "custom_vars": {},
  },
]
target_os = [ 'android', 'unix' ]
```

and then execute gclient sync

``` bash
gclient sync
```

5. compile

``` bash
# we currently in "/webrtc" directory
cd src
./tools_webrtc/android/build_aar.py --extra-gn-args "is_debug=true symbol_level=2 android_full_debug=true" --arch arm64-v8a
```

We also can use `gn` and `ninja` to make custom build. When build complete, the output file will auto synced to our host machine.


## FAQ

### Can we download the WebRTC source code on our host machine and map it into a Docker container?

No, you cannot do this effectively. If you download the WebRTC source code on your Mac, the compilation tools that are downloaded will be for the aarch64 architecture, not x86_64. This mismatch will lead to compilation errors when you try to build the code inside the Docker container.

I have attempted to resolve this issue by adding target_cpu = ['x64'] in the .gclient file, but it did not work. Therefore, it is necessary to download the source code directly within the Docker container to ensure compatibility with the x86_64 architecture.
