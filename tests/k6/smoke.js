import http from 'k6/http'; import { check, sleep } from 'k6';
export const options = { vus: 1, duration: '10s' };
export default function () {
  const res = http.get('http://localhost:8080/actuator/health');
  check(res, {'200 OK': (r)=> r.status===200}); sleep(1);
}
