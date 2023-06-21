function adj_job_num([int]$jn = 5, [string]$file_name = '.\test_config.txt')
    {
        $filecontent = Get-Content -Path $file_name
        $v_line = Get-Content $file_name | Select-String JobLastRun | Select-Object -ExpandProperty Line
        if ($null -eq $v_line)
            {
                "JobLastRun not found"
                exit
            }
        else 
            {
                $vsl = "JobLastRun                        "
                $vel = "                 # Last Run of the Job"
                $v_new_line = ($vsl, $jn, $vel -join " ")
                $filecontent.Replace($v_line, $v_new_line) | Set-Content $file_name
                Write-Output ("Last Job number adjusted to", $jn-join " " )
            }  
    }

function adj_bias([int]$vb = 38, [string]$file_name = '.\test_config.txt')
    {
        $filecontent = Get-Content -Path $file_name
        $v_line = Get-Content $file_name | Select-String HV_Vbias | Select-Object -ExpandProperty Line
        if ($null -eq $v_line)
            {
                "HV_VBias not found"
                exit
            }
        else 
            {
                $vsl = "HV_Vbias                          "
                $vel = "V                 # Bias voltage (common to all channels, fine adjustable channel by channel by `"HV_IndivAdj`")"
                $v_new_line = ($vsl, $vb, $vel -join " ")
                $filecontent.Replace($v_line, $v_new_line) | Set-Content $file_name
                Write-Output ("Bias voltage adjusted to", $vb, "V" -join " " )
            }  
    }

function adj_sleep([int]$slp_t = 15, [string]$file_name = '.\test_config.txt')
    {
        Write-Output $file_name
        $filecontent = Get-Content -Path $file_name
        $v_line = Get-Content $file_name | Select-String RunSleep | Select-Object -ExpandProperty Line
        if ($null -eq $v_line)
            {
                "Run Sleep not found"
                exit
            }
        else 
            {
                $vsl = "RunSleep                          " 
                $vel = "s                 # Wait Time between runs of a job"
                $v_new_line = ($vsl, $slp_t, $vel -join " ")
                $filecontent.Replace($v_line, $v_new_line) | Set-Content $file_name
                Write-Output ("Sleep time adjusted to", $slp_t, "s" -join " ")
            }  
    }
function adj_shape([int]$st = 25, [string]$file_name = '.\test_config.txt')
    {
        $filecontent = Get-Content -Path $file_name
        $s_line = Get-Content $file_name | Select-String HG_ShapingTime | Select-Object -ExpandProperty Line
        if ($null -eq $s_line)
            {
                "HG_ShapingTime not found"
                exit
            }
        else 
            {
                $ssl = "HG_ShapingTime                    "
                $sel = "ns                # Shaping Time of the slow shaper (High Gain). Options: 87.5 ns, 75 ns, 62.5 ns, 50 ns, 37.5 ns, 25 ns, 12.5 ns"
                $s_new_line = ($ssl, $st, $sel -join " ")
                $filecontent.Replace($s_line, $s_new_line) | Set-Content $file_name
                Write-Output ("High Gain Shaping Time", $st, "ns" -join " ")
            }  
    }
Get-ChildItem -Path .\Generated_config_files -Include *.* -File -Recurse | ForEach-Object { $_.Delete()}
$v_low_bound = 38
$v_up_bound = 43
$v_step = .5
$sleep_time = 15
$s_low_bound = 12.5
$s_up_bound = 87.5
$s_step = 12.5
$total_num_of_files = 2*(((($v_up_bound - $v_low_bound)/$v_step) + 1)*((($s_up_bound - $s_low_bound)/$s_step) + 1))
Write-Output $total_num_of_files
$run_counter = 1
$sample_config = ".\test_config.txt"
#Write-Output $sample_config
adj_sleep $sleep_time $sample_config
adj_job_num $total_num_of_files $sample_config
for($i = $v_low_bound; $i -le $v_up_bound; $i = $i + $v_step)
    {
        adj_bias $i $sample_config
        
        
        for($j = $s_low_bound; $j -le $s_up_bound; $j = $j + $s_step)
            {
                adj_shape $j $sample_config
                
                #Start-Process -Wait "notepad.exe"
                #$cmdOutput = <command>
                #Write-Output $cmdOutput
                $config_name = (".\Generated_config_files\Janus_Config_Run", $run_counter,".txt" -join "")
                New-Item $config_name -Force
                Get-Content $sample_config | Set-Content .\$config_name
                
                $sweep_down =  $total_num_of_files - $run_counter + 1
                $config_name = (".\Generated_config_files\Janus_Config_Run",$sweep_down,".txt" -join "")
                New-Item $config_name -Force
                Get-Content $sample_config | Set-Content .\$config_name
                
                $run_counter++
                Start-Sleep -Milliseconds 100 #optional, rarely can crash and corrupt files without it
            }
        
        #Write-Output $run_counter
        #$run_counter++
    }
