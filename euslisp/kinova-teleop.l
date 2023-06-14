(require "package://kinovaeus/kinova-interface.l")

(ros::roseus "kinova_teleop_node")
(unless (boundp '*tfl*)
  (defvar *tfl* (instance ros::transform-listener :init))
  )

(defun setup-env
    ()
  (kinova-init :type :gen3_robotiq_2f_140)
  (setq *robot* *kinova*)
  (send *robot* :angle-vector (send *ri* :state :potentio-vector))
  (objects (list *robot*))
  )

(defun solve-ik
    ()
   (let ((trans
         (send *tfl* :lookup-transform
               "/vive_base"
               "right_controller"
               (ros::time 0))))
     (send *robot* :rarm :inverse-kinematics trans :rotation-axis t :debug-view nil)
     )
   (send *irtviewer* :draw-objects)
   )

(defun ik-test
    ()
  (do-until-key
   (solve-ik)
   (x::window-main-one)
   )
  )

(defun main-loop
    ()
  (do-until-key
   (solve-ik)
   (x::window-main-one)
   (send *ri* :angle-vector (send *robot* :angle-vector))
   )
  )
