//
//  NotificacionesView.swift
//  gestorIncidencias
//
//  Created by  on 19/5/25.
//


import SwiftUI

struct NotificacionesView: View {
    @Binding var selectedTab: Tab
    @ObservedObject var viewModel: NotificacionesListViewModel
    @State private var notificacionSeleccionada: Notificacion? = nil
    @State private var mostrarDetalle = false

    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    HStack {
                        Image(systemName: "bell.fill")
                            .resizable()
                            .foregroundStyle(Color.white)
                            .scaledToFit()
                            .frame(height: 40)
                            .padding(.leading, 4)

                        Text("Notificaciones")
                            .foregroundColor(.white)
                            .font(.system(size: 26, weight: .bold))
                            .padding(.leading, 8)

                        Spacer()
                    }
                    .padding()
                    .background(Color.black)

                    if viewModel.notificaciones.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "tray")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                            Text("No hay notificaciones")
                                .foregroundColor(.gray)
                                .font(.headline)
                        }
                        .padding()
                    } else {
                        List(viewModel.notificaciones) { notificacion in
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text("De: \(notificacion.remitente?.name ?? "Sistema")")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)

                                    Spacer()

                                    Text(formatearFecha(notificacion.fechaEnvio))
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }

                                Text(notificacion.cuerpo)
                                    .font(.body)
                                    .foregroundColor(.primary)
                                    .lineLimit(2)

                                if !notificacion.leido {
                                    Text("● No leído")
                                        .font(.caption2)
                                        .foregroundColor(.blue)
                                }else{
                                    Text("● Leído")
                                        .font(.caption2)
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding(.vertical, 8)
                            .onTapGesture {
                                notificacionSeleccionada = notificacion
                                withAnimation {
                                    mostrarDetalle = true
                                }
                                if !notificacion.leido {
                                        viewModel.marcarNotificacionComoLeida(id: notificacion.id)
                                    }
                            }
                        }
                        .listStyle(.plain)
                        .refreshable {
                            viewModel.refetch()
                        }
                    }
                }
                .onChange(of: selectedTab) { _, newValue in
                    if newValue == .home {
                        viewModel.refetch()
                    }
                }
            }
            .blur(radius: mostrarDetalle ? 5 : 0)

            if let noti = notificacionSeleccionada, mostrarDetalle {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            mostrarDetalle = false
                        }
                    }

                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation {
                                mostrarDetalle = false
                            }
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title)
                                .foregroundColor(.gray)
                        }
                    }

                    Text("Remitente")
                        .font(.headline)
                    Text(noti.remitente?.name ?? "Sistema")
                        .font(.body)

                    Text("Fecha")
                        .font(.headline)
                    Text(formatearFecha(noti.fechaEnvio))
                        .font(.body)

                    Text("Mensaje")
                        .font(.headline)
                    Text(noti.cuerpo)
                        .font(.body)

                    if noti.leido == false {
                        Text("No leída")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }else{
                        Text("Leída")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }

                    Spacer()
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 20)
                .padding(40)
                .transition(.scale)
            }
        }
    }

    private func formatearFecha(_ isoString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short

        if let date = isoFormatter.date(from: isoString) {
            return formatter.string(from: date)
        } else {
            return isoString
        }
    }
}
