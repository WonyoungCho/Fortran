# Single & Master

`!$omp single`을 사용하면 임의의 한개의 thread에서만 작업을 한다. 이후 `!$omp end parallel`에서 모든 thread들은 모든 작업이 끝날 때까지 기다렸다가 join된다.
