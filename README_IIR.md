# DSP
IIR filter design
-IIR (infinite impulse response) filter design
In this part we are going to design an IIR filter with down specification by the bilinear  transformation

     
		
In the first place we must calculate N and    from eq.1
Eq.1 =>  
But first we using the bilinear transformation from eq.2
Eq.2 =>   
For these values the stopband specification (of the CT filters) met exactly and passband specification will be exceeded.
1-  
2- 
1&2   
 
 
 


H(s)

                                                      0.2147
--------------------------------------------------------------------------------------
             s5 + 2.379 s4+ 2.83 s3 + 2.08 s 2+ 0.945s  + 0.2147


H(z) 
                     0.2147 z5 + 1.073 z4 + 2.147 z3+ 2.147 z2 + 1.073 z + 0.2147
  -----------------------------------------------------------------------------------------------------------
                       103.1 z5 - 281.8 z4+ 340.1 z3 - 216.9 z2 + 72.17 z - 9.929
 2N poles are equally spaced on circle of radius Ωc   with  angular spacing of π/N symmetric with respect to the imaginary axis
  
poles location of H(-s) in the s-plane

 
 
Since Hc (Ωj) has 6 zeros at   resulting DT filter has 6 zeros at  .
Test 1: by giving filter several signal with different frequency the filter passes signals with frequency between 0<f<.35 πbut in the 0<f<.275π the output is similar to the given signal the output of .276π<f<.35π otherwise filter will not let the signal to pass 

 
Test 2: by giving WGN the PSD (power spectral density) of output and magnitude response ( ) will have similar shapes 
 

 

It is clear that PSD of WNG is became like  and WN became CN (color noise) and frequency of CN mainly have cover bandwidth of filter .

