import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct LibraryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var songs: [Song]
    @StateObject private var libraryViewModel = LibraryViewModel()
    @StateObject private var playerViewModel = PlayerViewModel()
    @State private var isImporterPresented = false
    @State private var isPlayerSheetPresented = false
    @State private var songToEdit: Song?
    @State private var newArtistName = ""
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                LinearGradient(
                    gradient: Gradient(colors: [Color(UIColor.systemBackground), Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    if songs.isEmpty {
                        emptyStateView
                    } else {
                        List {
                            ForEach(songs) { song in
                                SongRow(
                                    song: song,
                                    isPlaying: playerViewModel.currentSong?.id == song.id,
                                    action: { playerViewModel.play(song: song) },
                                    onEditArtist: {
                                        newArtistName = song.artist
                                        songToEdit = song
                                    }
                                )
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .padding(.vertical, 4)
                                .swipeActions(edge: .leading) {
                                    Button {
                                        newArtistName = song.artist
                                        songToEdit = song
                                    } label: {
                                        Label("Edit Artist", systemImage: "pencil")
                                    }
                                    .tint(.blue)
                                }
                            }
                            .onDelete(perform: deleteItems)
                        }
                        .listStyle(.plain)
                        .padding(.bottom, playerViewModel.currentSong != nil ? 80 : 0)
                    }
                }
                
                if let currentSong = playerViewModel.currentSong {
                    MiniPlayerView(
                        song: currentSong,
                        isPlaying: playerViewModel.isPlaying,
                        togglePlay: { playerViewModel.togglePlayPause() },
                        onTap: { isPlayerSheetPresented = true }
                    )
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding()
                    .sheet(isPresented: $isPlayerSheetPresented) {
                         PlayerView(viewModel: playerViewModel)
                    }
                }
            }
            .navigationTitle("MusicPlayer-L.M. Pro")
            .alert("Edit Artist", isPresented: Binding(
                get: { songToEdit != nil },
                set: { if !$0 { songToEdit = nil } }
            )) {
                TextField("Artist Name", text: $newArtistName)
                Button("Cancel", role: .cancel) {
                    songToEdit = nil
                }
                Button("Save") {
                    if let song = songToEdit {
                        song.artist = newArtistName.isEmpty ? "Unknown Artist" : newArtistName
                        // SwiftData autosaves, but we can force it if needed, usually not required.
                        songToEdit = nil
                    }
                }
            } message: {
                Text("Enter the artist name for this song.")
            }
            .alert("Playback Error", isPresented: $playerViewModel.showError) {
                Button("OK", role: .cancel) {
                    playerViewModel.showError = false
                }
            } message: {
                Text(playerViewModel.errorMessage ?? "An unknown error occurred")
            }
            .overlay(alignment: .top) {
                if playerViewModel.showStatus {
                    StatusOverlay(message: playerViewModel.statusMessage ?? "")
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { isImporterPresented = true }) {
                        Label("Add Music", systemImage: "plus.circle.fill")
                            .font(.title3)
                    }
                }
            }
            .fileImporter(
                isPresented: $isImporterPresented,
                allowedContentTypes: [.audio],
                allowsMultipleSelection: true
            ) { result in
                switch result {
                case .success(let urls):
                    libraryViewModel.importFiles(from: urls, modelContext: modelContext)
                case .failure(let error):
                    print("Import failed: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 150, height: 150)
                
                Image(systemName: "music.note.list")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
            }
            
            Text("Your Library is Empty")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Tap the + button to add music\nfrom your device files.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(songs[index])
            }
        }
    }
}

// MARK: - Subviews

struct SongRow: View {
    let song: Song
    let isPlaying: Bool
    let action: () -> Void
    let onEditArtist: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isPlaying ? Color.blue : Color.gray.opacity(0.1))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: isPlaying ? "speaker.wave.3.fill" : "music.note")
                        .foregroundColor(isPlaying ? .white : .blue)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(song.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    if song.artist.isEmpty || song.artist == "Unknown Artist" {
                        Text("Tap to Add Artist")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                            .padding(.vertical, 2)
                            .padding(.horizontal, 6)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(4)
                            .onTapGesture {
                                onEditArtist()
                            }
                    } else {
                        Text(song.artist)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                }
                
                Spacer()
                
                if isPlaying {
                    Image(systemName: "chart.bar.fill")
                        .foregroundColor(.blue)
                        .font(.caption)
                }
            }
            .padding(12)
            .background(Color(UIColor.secondarySystemGroupedBackground))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            .contextMenu {
                Button(action: onEditArtist) {
                    Label("Edit Artist", systemImage: "pencil")
                }
            }
        }
        .buttonStyle(.plain)
    }
}

struct MiniPlayerView: View {
    let song: Song
    let isPlaying: Bool
    let togglePlay: () -> Void
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.blue.opacity(0.2))
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: "music.quarternote.3")
                        .foregroundColor(.blue)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(song.title)
                        .font(.headline)
                        .lineLimit(1)
                    
                    Text("Tap to open player")
                        .font(.caption)
                        .foregroundColor(.blue)
                        .fontWeight(.medium)
                }
                
                Spacer()
                
                Button(action: togglePlay) {
                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.blue)
                        .background(Circle().fill(Color.white))
                }
            }
            .padding(12)
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

struct StatusOverlay: View {
    let message: String
    
    var body: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
            Text(message)
                .font(.subheadline)
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.black.opacity(0.8))
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.top, 50)
        .transition(.move(edge: .top).combined(with: .opacity))
    }
}
