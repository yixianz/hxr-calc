; rhessi_eff_area2.pro:
; Adapted from rhessi_eff_area.pro written by Pascal Saint-Hilaire:
; (only) change the return line so it could work for a single detector.   
; Y. Zhang 4/2/2021 
;
; Below is the header for rhessi_eff_area.pro:
;+
; PSH, 2005/07/19
;
; Made after G. Hurford's hessi_transestimator.pro.
;
; Units are in cm^2 (for all 9 detectors).
;
; EXAMPLES:
;	PRINT, rhessi_eff_area([12,25],0.001,1)
;	PRINT, rhessi_eff_area([12,25],0.25,0,detector=[1,3,4,5,6,8,9],/REAR)
;	PRINT, rhessi_eff_area([12,25,50],0.25,0,detector=[1,3,4,5,6,8,9])
;
;	PRINT, rhessi_eff_area([10,11],0.25,0,detector=[8,9])
;	PRINT, rhessi_eff_area([10.,11],0.25,0,detector=[8,9])
;
; Playing a bit with the routines, my experience is that hessi_drm_4image.pro is almost independent of which detector is being used,
; and that hessi_grm.pro seem completely independent of the attenuator state.
; Both of these routines actually accept eband_edges.
;
;-
FUNCTION rhessi_eff_area2, eband, radial_offset_, atten_state, detectors=detectors, powerlawindex=powerlawindex, REAR=REAR
	
	IF NOT KEYWORD_SET(detectors) THEN detectors=1+INDGEN(9)
	;IF NOT KEYWORD_SET(powerlawindex) THEN powerlawindex=4

	detector_label=[ '1f', '2f', '3f', '4f', '5f', '6f', '7f', '8f', '9f', $
			 '1r', '2r', '3r', '4r', '5r', '6r', '7r', '8r', '9r']

	drmgrm=DBLARR(N_ELEMENTS(eband)-1,N_ELEMENTS(detectors))
	FOR i=0, N_ELEMENTS(detectors)-1 DO BEGIN
		IF KEYWORD_SET(REAR) THEN id=detectors[i]+8 ELSE id=detectors[i]-1
radial_offset=radial_offset_
		hessi_drm_4image, drm, eband, detector_label[id], atten_state, OFFAX_POSITION=radial_offset	;, POWERLAWS=powerlawindex
radial_offset=radial_offset_
		hessi_grm, eband, detectors[i]-1, grm, atten_state, radial_offset	;, POWER_LAW=powerlawindex
		drmgrm[*,i]= drm*grm.gridtran
	ENDFOR		
	
	IF SIZE(drmgrm,/N_dimensions) EQ 1 THEN RETURN, 40.*drmgrm ELSE RETURN,40.*TOTAL(drmgrm,2)
	
END
