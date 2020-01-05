# Build
```bash
docker build -t dsmachine .
```

# Run
```bash
docker run \
    --name dsmachine \
    -p 8888:8888 \
    -v "notebooks:/home/dummy/dev/notebooks" \
    -d dsmachine
```
