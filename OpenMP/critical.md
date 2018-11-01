`!$omp critical` : 한 쓰레드가 계산하고 있으면 다른 쓰레드가 같은 메모리로의 접근을 못 하게한다.
`!$omp atomic` : `critical`과 같지만, 간단한 계산에서 쓰인다. Like mini-critical section.

