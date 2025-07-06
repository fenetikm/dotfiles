import psutil

# ref: https://github.com/nicolargo/glances/blob/develop/glances/plugins/cpu/__init__.py
usage = psutil.cpu_percent(interval=0.3)
stats = psutil.cpu_stats()
# scpustats(ctx_switches=97741, interrupts=1173962, soft_interrupts=2372446965, syscalls=2838831)
perc = psutil.cpu_times_percent(interval=0.3)
# scputimes(user=1.5, nice=0.0, system=1.9, idle=96.7)

cpu_user = perc.user
cpu_system = perc.system
