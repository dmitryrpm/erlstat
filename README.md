Erlstat - lightweight server statistics for your video server. 

#### INSTALL
```bash
git clone https://github.com/dmitryrpm/erlstat.git
cd erlstat/
bash start-dev.sh
```

#### CHECK 
Chech static
```bash
curl -D - http://localhost:8000/cors.html
curl -D - http://localhost:8000/crossdomain.xml
```
Check statistic
```bash
curl -D - http://localhost:8000/set?track_id=1
curl -D - http://localhost:8000/get?track_id=1
```
