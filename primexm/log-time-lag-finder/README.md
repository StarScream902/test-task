# Log time lag finder

create a script using any scripting language which will get both the current timestamp from the beginning of the line and the tag 52= from FIX message (sample data is attached) and print to the standard output as difference between two timestamps in seconds (with milliseconds) for any difference >= 10 milliseconds. Please note that the speed of execution is the most important metric here. Explain why you used a specific method and what alternative methods you’ve considered for this task.

Values to parse from the input:
```log
2022-12-09 12:00:32.502|871544 [INFO ] in : 8=FIX.4.4^A9=120^A35=i^A34=269603^A49=XCD371^A52=20221209-12:00:32.461^A56=Q022^A296=1^A302=EUR/USD_0^A295=1^A299=0^A106=4^A135=1500000^A190=1.05553^A10=158^A
```

Example output expected:
```log
2022-12-09 12:00:32.502|871544 [INFO ] in : 8=FIX.4.4^A9=120^A35=i^A34=269603^A49=XCD371^A52=20221209-12:00:32.461^A56=Q022^A296=1^A302=EUR/USD_0^A295=1^A299=0^A106=4^A135=1500000^A190=1.05553^A10=158^A
Time difference: 0.042
2022-12-09 12:00:32.504|873831 [INFO ] in : 8=FIX.4.4^A9=120^A35=i^A34=269604^A49=XCD371^A52=20221209-12:00:32.463^A56=Q022^A296=1^A302=EUR/USD_0^A295=1^A299=0^A106=2^A135=1000000^A190=1.05551^A10=152^A
Time difference: 0.041
2022-12-09 12:00:32.630|999628 [INFO ] in : 8=FIX.4.4^A9=107^A35=i^A34=269605^A49=XCD371^A52=20221209-12:00:32.589^A56=Q022^A296=1^A302=EUR/USD_0^A295=1^A299=0^A106=2^A188=1.0555^A10=085^A
2022-12-09 12:00:32.753|122246 [INFO ] in : 8=FIX.4.4^A9=119^A35=i^A34=269606^A49=XCD371^A52=20221209-12:00:32.712^A56=Q022^A296=1^A302=EUR/USD_0^A295=1^A299=0^A106=4^A135=500000^A190=1.05552^A10=118^A
Time difference: 0.041
```
