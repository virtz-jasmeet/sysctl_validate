*** Settings ***
Documentation                  Check & validate sysctl parameters and configuration
Library                        SSHLibrary
Suite Teardown                 Close All Connections


*** Variables ***
@{ALLHOSTS}=           10.189.153.69  10.189.153.70  10.189.153.71  10.189.153.72  10.189.153.73  10.189.153.74  10.189.153.75
@{CONTROLLERS}=     10.189.153.69  10.189.153.70  10.189.153.71
@{COMPUTES}=        10.189.153.72  10.189.153.73  10.189.153.74  10.189.153.75
${USERNAME}         root
${PASSWORD}         STRANGE-EXAMPLE-neither

*** Test Cases ***
Check sysctl.conf on All Nodes
    [Documentation]			Check sysctl.conf on All Nodes
    FOR  ${HOST}  IN  @{ALLHOSTS}
        open connection         ${HOST}
        login                   ${USERNAME}  ${PASSWORD}  False  True
        Put File                sysctl.config_data  /root  mode=0660
        SSHLibrary.File Should Exist   /root/sysctl.config_data
        ${output}=              execute command   diff -is /root/sysctl.config_data /etc/sysctl.conf
        Run Keyword And Continue On Failure     should contain    ${output}    identical
        execute command         rm -f /root/sysctl.config_data
        close connection
    END

Check 00-io.ctlsdn.host.13-tuning.conf on All Nodes
    [Documentation]			Check 00-io.ctlsdn.host.13-tuning.conf on All Nodes
    FOR  ${HOST}  IN  @{ALLHOSTS}
        open connection         ${HOST}
        login                   ${USERNAME}  ${PASSWORD}  False  True
        Put File                00-io.ctlsdn.host.13-tuning.config_data  /root  mode=0660
        SSHLibrary.File Should Exist   /root/00-io.ctlsdn.host.13-tuning.config_data
        ${output}=              execute command   diff -is /root/00-io.ctlsdn.host.13-tuning.config_data /etc/sysctl.d/00-io.ctlsdn.host.13-tuning.conf
        Run Keyword And Continue On Failure     should contain    ${output}    identical
        execute command         rm -f /root/00-io.ctlsdn.host.13-tuning.config_data
        close connection
    END

Check 10-io.ctlsdn.cluster.storage.ceph.conf on All Nodes
    [Documentation]			Check 10-io.ctlsdn.cluster.storage.ceph.conf on All Nodes
    FOR  ${HOST}  IN  @{ALLHOSTS}
        open connection         ${HOST}
        login                   ${USERNAME}  ${PASSWORD}  False  True
        Put File                10-io.ctlsdn.cluster.storage.ceph.config_data  /root  mode=0660
        SSHLibrary.File Should Exist   /root/10-io.ctlsdn.cluster.storage.ceph.config_data
        ${output}=              execute command   diff -is /root/10-io.ctlsdn.cluster.storage.ceph.config_data /etc/sysctl.d/10-io.ctlsdn.cluster.storage.ceph.conf
        Run Keyword And Continue On Failure     should contain    ${output}    identical
        execute command         rm -f /root/10-io.ctlsdn.cluster.storage.ceph.config_data
        close connection
    END

Check 20-io.ctlsdn.psbos.31-infrastructure.loadbalancer.conf on All Controller Nodes
    [Documentation]			Check 20-io.ctlsdn.psbos.31-infrastructure.loadbalancer.conf on All Controller Nodes
    FOR  ${HOST}  IN  @{CONTROLLERS}
        open connection         ${HOST}
        login                   ${USERNAME}  ${PASSWORD}  False  True
        Put File                20-io.ctlsdn.psbos.31-infrastructure.loadbalancer.config_data  /root  mode=0660
        SSHLibrary.File Should Exist   /root/20-io.ctlsdn.psbos.31-infrastructure.loadbalancer.config_data
        ${output}=              execute command   diff -is /root/20-io.ctlsdn.psbos.31-infrastructure.loadbalancer.config_data /etc/sysctl.d/20-io.ctlsdn.psbos.31-infrastructure.loadbalancer.conf
        Run Keyword And Continue On Failure     should contain    ${output}    identical
        execute command         rm -f /root/20-io.ctlsdn.psbos.31-infrastructure.loadbalancer.config_data
        close connection
    END

Validate sysctl -a on Controller Nodes
    [Documentation]			Validate sysctl -a on Controller Nodes
    FOR  ${HOST}  IN  @{CONTROLLERS}
        open connection         ${HOST}
        login                   ${USERNAME}  ${PASSWORD}  False  True
        Put File                sysctl_output_controller  /root  mode=0660
        SSHLibrary.File Should Exist   /root/sysctl_output_controller
        ${output}=              execute command   sysctl -a | sort > /root/sysctl_output_controller_local
        SSHLibrary.File Should Exist   /root/sysctl_output_controller_local
        ${output}=              execute command   diff -is /root/sysctl_output_controller /root/sysctl_output_controller_local
        Run Keyword And Continue On Failure     should contain    ${output}    identical
        execute command         rm -f /root/sysctl_output_controller /root/sysctl_output_controller_local
        close connection
    END

Validate sysctl -a on Compute Nodes
    [Documentation]			Validate sysctl -a on Compute Nodes
    FOR  ${HOST}  IN  @{COMPUTES}
        open connection         ${HOST}
        login                   ${USERNAME}  ${PASSWORD}  False  True
        Put File                sysctl_output_compute  /root  mode=0660
        SSHLibrary.File Should Exist   /root/sysctl_output_compute
        ${output}=              execute command   sysctl -a | sort > /root/sysctl_output_compute_local
        SSHLibrary.File Should Exist   /root/sysctl_output_compute_local
        ${output}=              execute command   diff -is /root/sysctl_output_compute /root/sysctl_output_compute_local
        Run Keyword And Continue On Failure     should contain    ${output}    identical
        execute command         rm -f /root/sysctl_output_compute /root/sysctl_output_compute_local
        close connection
    END


*** Keywords ***
