//
//  ContentView.swift
//  TinyToyTank
//
//  Created by 박건우 on 7/13/24.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    var body: some View {
        ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    func makeUIView(context: Context) -> ARView {
        let turretLeftButton = self.makeControlButton(imageName: "TurretLeft")
        let cannonFireButton = self.makeControlButton(imageName: "CannonFire")
        let turretRightButton = self.makeControlButton(imageName: "TurretRight")
        let tankLeftButton = self.makeControlButton(imageName: "TankLeft")
        let tankForwardButton = self.makeControlButton(imageName: "TankForward")
        let tankRightButton = self.makeControlButton(imageName: "TankRight")
        turretLeftButton.addTarget(context.coordinator, action: #selector(context.coordinator.turretLeftPressed), for: .touchUpInside)
        cannonFireButton.addTarget(context.coordinator, action: #selector(context.coordinator.cannonFirePressed), for: .touchUpInside)
        turretRightButton.addTarget(context.coordinator, action: #selector(context.coordinator.turretRightPressed), for: .touchUpInside)
        tankLeftButton.addTarget(context.coordinator, action: #selector(context.coordinator.tankLeftPressed), for: .touchUpInside)
        tankForwardButton.addTarget(context.coordinator, action: #selector(context.coordinator.tankForwardPressed), for: .touchUpInside)
        tankRightButton.addTarget(context.coordinator, action: #selector(context.coordinator.tankRightPressed), for: .touchUpInside)
        
        let turretControlView = UIStackView(arrangedSubviews: [turretLeftButton, cannonFireButton, turretRightButton])
        let tankControlView = UIStackView(arrangedSubviews: [tankLeftButton, tankForwardButton, tankRightButton])
        let controlView = UIStackView(arrangedSubviews: [turretControlView, tankControlView])
        turretControlView.axis = .horizontal
        tankControlView.axis = .horizontal
        controlView.axis = .vertical
        
        let arView = ARView(frame: .zero)
        context.coordinator.tankAnchor = try! TinyToyTank.load_TinyToyTank()
        arView.scene.anchors.append(context.coordinator.tankAnchor!)
        context.coordinator.tankAnchor!.cannon?.setParent(context.coordinator.tankAnchor!.tank, preservingWorldTransform: true)
        context.coordinator.tankAnchor?.actions.actionComplete.onAction = { _ in
            context.coordinator.isActionPlaying = false
        }
        arView.addSubview(controlView)
        
        controlView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            controlView.bottomAnchor.constraint(equalTo: arView.safeAreaLayoutGuide.bottomAnchor),
            controlView.trailingAnchor.constraint(equalTo: arView.safeAreaLayoutGuide.trailingAnchor),
        ])
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    private func makeControlButton(imageName: String) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: imageName), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 80),
            button.heightAnchor.constraint(equalToConstant: 80),
        ])
        return button
    }
    
    @MainActor
    final class Coordinator: NSObject {
        var tankAnchor: TinyToyTank._TinyToyTank?
        var isActionPlaying: Bool = false
        
        @objc func turretLeftPressed() {
            if self.isActionPlaying {
                return
            } 
            else {
                self.isActionPlaying = true
            }
            self.tankAnchor?.notifications.turretLeft.post()
        }
        
        @objc func cannonFirePressed() {
            if self.isActionPlaying {
                return
            } 
            else {
                self.isActionPlaying = true
            }
            self.tankAnchor?.notifications.cannonFire.post()
        }
        
        @objc func turretRightPressed() {
            if self.isActionPlaying {
                return
            } 
            else {
                self.isActionPlaying = true
            }
            self.tankAnchor?.notifications.turretRight.post()
        }
        
        @objc func tankLeftPressed() {
            if self.isActionPlaying {
                return
            }
            else {
                self.isActionPlaying = true
            }
            self.tankAnchor?.notifications.tankLeft.post()
        }
        
        @objc func tankForwardPressed() {
            if self.isActionPlaying {
                return
            }
            else {
                self.isActionPlaying = true
            }
            self.tankAnchor?.notifications.tankForward.post()
        }
        
        @objc func tankRightPressed() {
            if self.isActionPlaying {
                return
            }
            else {
                self.isActionPlaying = true
            }
            self.tankAnchor?.notifications.tankRight.post()
        }
    }
}

#Preview {
    ContentView()
}
