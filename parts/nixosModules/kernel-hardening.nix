{
  flake.nixosModules.kernel-hardening = {...}: {
    # Kernel hardening via sysctl parameters
    # These settings enhance security against network and local attacks

    boot.kernel.sysctl = {
      # Network hardening
      "net.ipv4.conf.all.rp_filter" = 1; # Enable reverse path filtering
      "net.ipv4.conf.default.rp_filter" = 1;
      "net.ipv4.icmp_echo_ignore_broadcasts" = 1; # Ignore ICMP broadcast requests
      "net.ipv4.conf.all.accept_source_route" = 0; # Disable source routing
      "net.ipv4.conf.default.accept_source_route" = 0;
      "net.ipv4.conf.all.send_redirects" = 0; # Disable ICMP redirects
      "net.ipv4.conf.default.send_redirects" = 0;
      "net.ipv4.conf.all.accept_redirects" = 0;
      "net.ipv4.conf.default.accept_redirects" = 0;
      "net.ipv4.conf.all.secure_redirects" = 0;
      "net.ipv4.conf.default.secure_redirects" = 0;
      "net.ipv4.tcp_syncookies" = 1; # Enable SYN cookies for SYN flood protection
      "net.ipv4.icmp_ignore_bogus_error_responses" = 1; # Ignore bogus ICMP errors
      "net.ipv4.conf.all.log_martians" = 1; # Log martian packets (spoofed)
      "net.ipv4.conf.default.log_martians" = 1;

      # IPv6 hardening (disable if not using IPv6)
      "net.ipv6.conf.all.disable_ipv6" = 1;
      "net.ipv6.conf.default.disable_ipv6" = 1;
      "net.ipv6.conf.lo.disable_ipv6" = 1;

      # Kernel hardening
      "kernel.dmesg_restrict" = 1; # Restrict dmesg access to root only
      "kernel.kptr_restrict" = 2; # Hide kernel pointers in /proc
      "kernel.unprivileged_bpf_disabled" = 1; # Disable unprivileged BPF
      "net.core.bpf_jit_harden" = 2; # Harden BPF JIT compiler
      "kernel.yama.ptrace_scope" = 2; # Restrict ptrace to admin only
      "kernel.kexec_load_disabled" = 1; # Disable kexec (prevents kernel replacement)

      # File system hardening
      "fs.protected_hardlinks" = 1; # Protect against hardlink attacks
      "fs.protected_symlinks" = 1; # Protect against symlink attacks
      "fs.protected_fifos" = 2; # Protect FIFOs in sticky directories
      "fs.protected_regular" = 2; # Protect regular files in sticky directories
      "fs.suid_dumpable" = 0; # Disable core dumps for SUID binaries

      # Additional security
      "kernel.core_uses_pid" = 1; # Append PID to core dump filenames
      "kernel.panic" = 10; # Reboot after 10 seconds on kernel panic
      "vm.mmap_min_addr" = 65536; # Minimum virtual memory address for user processes
    };
  };
}
