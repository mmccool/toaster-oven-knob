// Toaster Oven Knob
// Michael McCool 2020
sm = 30;
tol = 0.1;
eps = 0.01;

// Minkowski rounding radius
m_r = 1;
m_sm = sm;

layer_h = 0.2 + eps;
line_w = 0.8;

// print scale correction
sc = true;
sx = sc ? 0.97*15.2/15.6 : 1.0;
sy = sc ? 0.97*15.2/15.6 : 1.0;
sz = sc ? 15.2/14 : 1.0;

knob_r = 10/2;
knob_ir = 6/2;
knob_R = 35/2;
knob_h = 8;
knob_h2 = 3;
knob_h3 = 5;
knob_s = 2;
knob_sm = 4*sm;

support_h = layer_h;
support_R = knob_R + 10;
support_H = knob_h - layer_h - eps;
support_s = 2*line_w + eps;

module support() {
  difference() {
    union() {
      color([0.5,0,0]) cylinder(r=support_R,h=support_h);
      color([0.5,0,0]) cylinder(r=knob_R,h=support_H-2*layer_h-eps,$fn=knob_sm);
      color([0.5,0.2,0]) for (r = [0 : 2*support_s : knob_R]) {
        difference() {
          cylinder(r=r+support_s,h=support_H,$fn=knob_sm);
          cylinder(r=r,h=support_H+tol,$fn=knob_sm);
        }
      }
      color([0.5,0.2,0]) for (a = [0 : 30 : 360]) {
        rotate(a)
          translate([-support_s/2,0,0])
            cube([support_s,knob_R,support_H]);
      }
    }
    color([0.5,0,0]) translate([0,0,support_h])
      cylinder(r=knob_r+2*line_w+tol,h=knob_h+2*tol,$fn=knob_sm);
  }
}

knob_h4 = 25;
knob_tt = 4;
knob_w = knob_R;
knob_t = 2*knob_ir + knob_tt;
knob_rr = 1;
knob_ox = 2*knob_t/3;
knob_oy = -knob_t/4;
knob_or1 = 8;
knob_or2 = 5;
knob_oe = -0.25;
knob_of = -0.5;

module knob() {
  difference() {
    union() {
      minkowski() {
        sphere(r=m_r,$fn=m_sm);
        union() {
          // base
          translate([0,0,knob_h])
            cylinder(r=knob_R-m_r,h=knob_h2-m_r+eps,$fn=knob_sm);
          translate([0,0,knob_h+knob_h2-m_r])
            cylinder(r1=knob_R-m_r,r2=knob_R/2-m_r,h=knob_h3-knob_h2-m_r,$fn=knob_sm);
          // handle
          intersection() {
            intersection() {
              translate([0,0,knob_h])
                cylinder(r=knob_R-m_r-knob_of,h=knob_h4-m_r+eps,$fn=knob_sm);
              hull() {
                translate([-knob_R+knob_or1+knob_oe,knob_R,knob_h4-knob_or1])
                  rotate([90,0,0])
                    cylinder(r=knob_or1-m_r,h=2*knob_R,$fn=knob_sm);
                translate([-knob_R+knob_or1+knob_oe,knob_R-eps,0])
                  rotate([90,0,0])
                    cylinder(r=knob_or1-m_r,h=2*knob_R,$fn=knob_sm);
                translate([knob_R-knob_or2-knob_oe,knob_R,knob_h4-knob_or2])
                  rotate([90,0,0])
                    cylinder(r=knob_or2-m_r,h=2*knob_R,$fn=knob_sm);
                translate([knob_R-knob_or2-knob_oe,knob_R,0])
                  rotate([90,0,0])
                    cylinder(r=knob_or2-m_r,h=2*knob_R,$fn=knob_sm);
              }
            }
            union() {
              translate([knob_ox, -knob_t/2+m_r+knob_oy, knob_h]) 
                cube([knob_w, knob_t-2*m_r, knob_h4-knob_h-m_r]);
              translate([-knob_w-knob_ox, -knob_t/2+m_r-knob_oy, knob_h]) 
                cube([knob_w, knob_t-2*m_r, knob_h4-knob_h-m_r]);
              hull() {
                translate([knob_ox, -knob_t/2+m_r+knob_oy, knob_h]) 
                  cube([eps, knob_t-2*m_r, knob_h4-knob_h-m_r]);
                translate([-eps-knob_ox, -knob_t/2+m_r-knob_oy, knob_h]) 
                  cube([eps, knob_t-2*m_r, knob_h4-knob_h-m_r]);
              }
            }
          }
        }
      }
      cylinder(r=knob_r,h=knob_h+eps,$fn=knob_sm);
    }
    // shaft hole and slot
    translate([0,0,-eps])
      cylinder(r=knob_ir,h=knob_h4-knob_tt,$fn=knob_sm);
    translate([-knob_s/2,-knob_r-tol,-tol])
      cube([knob_s,2*knob_r+2*tol,knob_h+tol]);
  }
}

// VISUALIZE
module viz() {
  //support();
  knob();
}
viz();

// PRINT
module print() {
  scale([sx,sy,sz]) {
    support();
    knob();
  }
}
// print();
