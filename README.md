# Heap benchmark

## Environment

- Zig 0.13.0
- Linux 6.11.6-arch1-1 x86_64 unknown
- CPU:

```
processor   : 0
vendor_id   : AuthenticAMD
cpu family  : 25
model       : 80
model name  : AMD Ryzen 7 5800H with Radeon Graphics
stepping    : 0
microcode   : 0xa50000c
cpu MHz     : 400.000
cache size  : 512 KB
physical id : 0
siblings    : 16
core id     : 0
cpu cores   : 8
apicid      : 0
initial apicid  : 0
fpu     : yes
fpu_exception   : yes
cpuid level : 16
wp      : yes
flags       : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good nopl xtopology nonstop_tsc cpuid extd_apicid aperfmperf rapl pni pclmulqdq monitor ssse3 fma cx16 sse4_1 sse4_2 movbe popcnt aes xsave avx f16c rdrand lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit wdt tce topoext perfctr_core perfctr_nb bpext perfctr_llc mwaitx cpb cat_l3 cdp_l3 hw_pstate ssbd mba ibrs ibpb stibp vmmcall fsgsbase bmi1 avx2 smep bmi2 erms invpcid cqm rdt_a rdseed adx smap clflushopt clwb sha_ni xsaveopt xsavec xgetbv1 xsaves cqm_llc cqm_occup_llc cqm_mbm_total cqm_mbm_local user_shstk clzero irperf xsaveerptr rdpru wbnoinvd cppc arat npt lbrv svm_lock nrip_save tsc_scale vmcb_clean flushbyasid decodeassists pausefilter pfthreshold avic v_vmsave_vmload vgif v_spec_ctrl umip pku ospke vaes vpclmulqdq rdpid overflow_recov succor smca fsrm debug_swap
bugs        : sysret_ss_attrs spectre_v1 spectre_v2 spec_store_bypass srso ibpb_no_ret
bogomips    : 6390.01
TLB size    : 2560 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 48 bits physical, 48 bits virtual
power management: ts ttp tm hwpstate cpb eff_freq_ro [13] [14]
```

## Benchmarks

```
$ zig build -Doptimize=ReleaseFast run


  Operating System: linux x86_64
  CPU:              AMD Ryzen 7 5800H with Radeon Graphics
  CPU Cores:        8
  Total Memory:     27.271GiB


benchmark              runs     total time     time/run (avg ± σ)     (min ... max)                p75        p99        p995
-----------------------------------------------------------------------------------------------------------------------------
B_HeapInsert           8191     1.499s         183.021us ± 31.67us    (166.5us ... 814.134us)      185.147us  270.284us  476.942us
B_HeapInsertWithAlloc  8191     1.541s         188.167us ± 29.909us   (170.621us ... 750.858us)    190.316us  241.998us  462.346us
B_HeapDeleteMin        2047     1.228s         600.258us ± 33.905us   (563.894us ... 1.105ms)      610.198us  762.102us  788.432us
Q_HeapInsert           8191     1.22s          149.062us ± 30.254us   (133.326us ... 752.255us)    150.297us  187.173us  440.486us
Q_HeapInsertWithAlloc  8191     1.225s         149.659us ± 27.223us   (135.073us ... 760.078us)    151.624us  184.589us  339.706us
Q_HeapDeleteMin        2047     1.108s         541.296us ± 29.77us    (508.65us ... 798.35us)      554.117us  679.271us  704.693us
P_HeapInsert           65535    950.686ms      14.506us ± 8.855us     (11.943us ... 966.388us)     14.387us   24.305us   27.168us
P_HeapDeleteMin        2047     1.908s         932.325us ± 44.969us   (870.776us ... 1.382ms)      950.813us  1.116ms    1.156ms
```
