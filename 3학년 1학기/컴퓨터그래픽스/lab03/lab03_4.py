import glfw
from OpenGL.GL import *
from OpenGL.GLU import *
import numpy as np

gCamAng = 0.

def render(camAng):
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
    glEnable(GL_DEPTH_TEST)

    # set the current matrix to the identity matrix
    glLoadIdentity()

    # use orthogonal projection (multiply the current matrix by "projection" matrix)
    gluLookAt(.1*np.sin(camAng), .1, .1*np.cos(camAng), 0, 0, 0, 0, 1, 0)

    # draw coordinates
    glBegin(GL_LINES)
    glColor3ub(255, 0, 0)
    glVertex3fv(np.array([0., 0., 0.]))
    glVertex3fv(np.array([1., 0., 0.]))
    glColor3ub(0, 255, 0)
    glVertex3fv(np.array([0., 0., 0.]))
    glVertex3fv(np.array([0., 1., 0.]))
    glColor3ub(0, 0, 255)
    glVertex3fv(np.array([0., 0., 0.]))
    glVertex3fv(np.array([0., 0., 1.]))
    glEnd()

    glColor3ub(255, 255, 255)
    # rotate 60 deg about x axis
    # 1)
    glRotatef(60, 1, 0, 0)
    drawTriangle()

    # 2)
    # th = np.radians(60)
    # R = np.identity(4)
    # R[:3, :3] = [[1., 0., 0.],
    #              [0., np.cos(th), -np.sin(th)],
    #              [0., np.sin(th), np.cos(th)]]
    # drawTriangleTransformedBy(R)

def drawTriangle():
    glBegin(GL_TRIANGLES)
    glVertex3fv(np.array([.0, .5, 0.]))
    glVertex3fv(np.array([.0, .0, 0.]))
    glVertex3fv(np.array([.5, .0, 0.]))
    glEnd()

def drawTriangleTransformedBy(M):
    glBegin(GL_TRIANGLES)
    glVertex3fv((M @ np.array([.0, .5, 0., 1.]))[:-1])
    glVertex3fv((M @ np.array([.0, .0, 0., 1.]))[:-1])
    glVertex3fv((M @ np.array([.5, .0, 0., 1.]))[:-1])
    glEnd() 

def key_callback(window, key, scancode, action, mods):
    global gCamAng
    # rotate the camera when 1 or 3 key is pressed or repeated
    if action == glfw.PRESS or action == glfw.REPEAT: 
        if key == glfw.KEY_1:
            gCamAng += np.radians(-10)
        elif key == glfw.KEY_3:
            gCamAng += np.radians(10)

def main():
    if not glfw.init():
        return
    window = glfw.create_window(640, 640, "OpenGL Trans. Functions", None, None)
    if not window:
        glfw.terminate()
        return
    glfw.make_context_current(window)
    glfw.set_key_callback(window, key_callback)

    while not glfw.window_should_close(window):
        glfw.poll_events()
        render(gCamAng)
        glfw.swap_buffers(window)
    
    glfw.terminate()

if __name__ == "__main__":
    main()