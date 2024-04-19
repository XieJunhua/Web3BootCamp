#### build a mini blockchain by python
```python
python blockchain.py
```

mine endpoint: http://localhost:5005/mine
full chain endpoint: http://localhost:5005/chain

![chain screenshot](image.png)

step1: deploy with an address
![pg1](image-1.png)

step2: call method with litter eth, will revert
![pg2](image-2.png)

step3: call method with 1 eth, will success
![pg3](image-3.png)

step4: 0x5B call withdraw will occur error
![pg4](image-4.png)

step5: 0x61 call withdraw will success
![alt text](image-5.png)
